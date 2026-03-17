//
//  TicketPrinterView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/16/26.
//

import Core
import UIKit
import SnapKit
import Then

/// 티켓이 슬롯에서 아래로 출력되는 애니메이션을 제공하는 뷰입니다.
///
/// ```swift
/// let printerView = TicketPrinterView()
/// printerView.configure(
///   bookItem: book,
///   departure: departureAirport,
///   destination: destinationAirport
/// )
/// printerView.startPrintAnimation()
/// ```
/// - Note:
///   - 티켓은 하단 바코드 영역부터 먼저 출력되도록 구성되어 있습니다.
///   - 출력 애니메이션은 `revealContainerView`의 높이를 늘리는 방식으로 구현됩니다.
///   - 출력 중 햅틱은 `Timer`를 사용해 반복적으로 발생합니다.
///   - 출력 완료 시 성공 햅틱이 발생합니다.
///   - 티켓은 고정 높이로 530 입니다.
public final class TicketPrinterView: BaseView {
  /// 프린트 애니메이션이 끝났을 때 이벤트
  public var onPrintAnimationCompleted: (() -> Void)?
  
  // MARK: - UI
  private let slotView = UIView().then {
    $0.backgroundColor = .n50
    $0.layer.borderWidth = 2
    $0.layer.borderColor = UIColor.n0.cgColor
    $0.layer.cornerRadius = 4
  }
  
  // 티켓이 점차 드러나는 컨테이너 영역 뷰
  private let revealContainerView = UIView().then {
    $0.clipsToBounds = true
    $0.backgroundColor = .clear
  }
  
  private let ticketView = TicketView()
  
  // 티켓 노출 높이를 제어하는 스냅킷 제약
  private var revealHeightConstraint: Constraint?
  
  // 티켓의 고정 높이
  private let ticketHeight: CGFloat = 530
  
  // 햅틱 타이머
  private var hapticTimer: Timer?
  
  // 햅틱 제너레이터
  private let hapticGenerator = UIImpactFeedbackGenerator(style: .heavy) // 햅틱
  
  public override func configureUI() {
    [
      slotView,
      revealContainerView
    ].forEach {
      addSubview($0)
    }
    
    revealContainerView.addSubview(ticketView)
  }
  
  public override func setupLayout() {
    slotView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.height.equalTo(6)
    }
    
    revealContainerView.snp.makeConstraints {
      $0.top.equalTo(slotView.snp.bottom)
      $0.horizontalEdges.equalToSuperview()
      revealHeightConstraint = $0.height.equalTo(0).constraint
      $0.bottom.lessThanOrEqualToSuperview()
    }
    
    // 티켓은 컨테이너 하단에 고정
    // 애니메이션 시 바코드 영역부터 먼저 출력되도록
    ticketView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalTo(ticketHeight)
    }
  }
  
  // MARK: - Public Method
  /// 티켓 출력 애니메이션을 시작합니다.
  public func startPrintAnimation() {
    layoutIfNeeded()
    reset()
    
    let totalHeight = min(bounds.height - 6, ticketHeight)
    guard totalHeight > 0 else { return }
    
    hapticGenerator.prepare()
    startHaptics()
    
    revealHeightConstraint?.update(offset: totalHeight)
    
    UIView.animate(
      withDuration: 2.2,
      delay: 0.1,
      options: [.curveLinear]
    ) {
      self.layoutIfNeeded()
    } completion: { _ in
      self.stopHaptics()
      
      let finishGenerator = UINotificationFeedbackGenerator()
      finishGenerator.notificationOccurred(.success)
      
      self.onPrintAnimationCompleted?()
    }
  }
  
  public func configure(
    bookItem: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo
  ) {
    ticketView.configure(
      bookItem: bookItem,
      departure: departure,
      destination: destination
    )
  }
}

// MARK: - Private
private extension TicketPrinterView {
  // 출력 상태 초기화
  // 티켓 노출 높이를 0으로 되돌리고, 진행 중인 햅틱을 중지함.
  func reset() {
    stopHaptics()
    revealHeightConstraint?.update(offset: 0)
    layoutIfNeeded()
  }
  
  // 햅틱 타이머
  func startHaptics() {
    stopHaptics()
    
    // withTimeInterval로 간격 조절
    hapticTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
      guard let self else { return }
      // intensity로 햅틱 세기 조절
      self.hapticGenerator.impactOccurred(intensity: 1.0)
      // 햅틱 응답성이 좋아진다?
      self.hapticGenerator.prepare()
    }
  }
  
  // 햅틱 중지
  func stopHaptics() {
    hapticTimer?.invalidate()
    hapticTimer = nil
  }
}
