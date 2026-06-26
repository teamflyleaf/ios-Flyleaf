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
/// swift
/// let printerView = TicketPrinterView()
/// printerView.configure(
///   bookItem: book,
///   departure: departureAirport,
///   destination: destinationAirport
/// )
/// printerView.isTearEnabled = true
/// printerView.startPrintAnimation()
///
/// - Note:
///   - 티켓은 하단 바코드 영역부터 먼저 출력되도록 구성되어 있습니다.
///   - 티켓은 고정 높이로 530 입니다.
///   - isTearEnabled가 true인 경우에만 프린트 완료 후 찢기 인터랙션이 활성화됩니다.
///   - 찢기 인터랙션 활성화 후 2초간 사용자 입력이 없으면 찢기 유도 힌트 애니메이션이 자동으로 시작됩니다.
public final class TicketPrinterView: BaseView {
  // 프린트 애니메이션 완료 시 호출되는 이벤트
  public var onPrintAnimationCompleted: (() -> Void)?
  
  // 티켓 찢기 완료 시 호출되는 이벤트
  public var onTearCompleted: (() -> Void)?
  
  // 티켓 찢기 상태 바뀔 때 호출되는 이벤트
  public var onTearProgressChanged: ((Bool) -> Void)?
  
  /// 티켓 찢기 기능 활성화 여부입니다
  public var isTearEnabled: Bool = false
  
  private var isTearCompleted: Bool = false
  
  // 좌 우 스와이프 감지하는 제스처
  private lazy var panGesture = UIPanGestureRecognizer(
    target: self,
    action: #selector(handlePanGesture(_:))
  )
  
  // 프린트 애니메이션 완료 여부
  private var isPrintCompleted = false
  
  // 티켓을 찢는 중인지?
  private var isTearing = false
  
  // 티켓 점선 기준 Y비율
  private let tearLineYRatio: CGFloat = 0.78
  
  // 티켓 찢기 시작을 허용하는 오차 범위임. 정확히 점선 위를 누르지 않아도 여유있게 찢기 가능
  private let tearActivationInset: CGFloat = 28
  
  // 진행도가 이 비율 이상이면 자동으로 찢기 완료 처리함. 85% 이상에서 자동 완료
  private let tearAutoCompleteRatio: CGFloat = 0.85
  
  // 현재까지 찢긴 진행도를 가로 길이 기준으로 저장
  private var tearProgressX: CGFloat = 0
  
  // pan 시작 시점의 진행도
  private var panStartProgressX: CGFloat = 0
  
  // 찢기 중 사용하는 햅틱 제너레이터
  private let tearHapticGenerator = UIImpactFeedbackGenerator(style: .rigid)
  
  // 마지막으로 햅틱이 발생한 진행도 위치임. 너무 자주 울리지 않게 하기 위함
  private var lastHapticProgress: CGFloat = 0
  
  // 찢긴 햅틱 발생 간격
  private let hapticStep: CGFloat = 8
  
  // 점선 아래 바코드 영역을 스냅샷으로 분리한 뷰임. 실제로 찢기는 애니메는 이 뷰를 회전하고 이동시키며 구현
  private var bottomPieceView: UIView?
  
  // 티켓 노출 높이를 제어하는 스냅킷 제약
  private var revealHeightConstraint: Constraint?
  
  // 티켓의 고정 높이
  private let ticketHeight: CGFloat = 530
  
  // 햅틱  타이머
  private var hapticTimer: Timer?
  
  // 햅틱 제너레이터
  private let hapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
  
  // 힌트 애니메이션 노출 타이머 -> 2초 뒤 힌트 애니메이션 실행
  private var hintAnimationTimer: Timer?
  
  // MARK: - UI
  private let slotView = UIView().then {
    $0.backgroundColor = .n20
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
  
  // 찢기 유도 원형 뷰
  private let hintView = UIView().then {
    $0.backgroundColor = UIColor.n0.withAlphaComponent(0.4)
    $0.layer.cornerRadius = 20
    $0.alpha = 0
    $0.isUserInteractionEnabled = false
    $0.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
  }
  
  public override func configureUI() {
    addSubview(slotView)
    addSubview(revealContainerView)
    revealContainerView.addSubview(ticketView)
    revealContainerView.addSubview(hintView)
    
    // 프린트 완료 전까지 찢기는 제스처 비활성화
    panGesture.isEnabled = false
    revealContainerView.addGestureRecognizer(panGesture)
    
    registerForTraitChanges(
      [UITraitUserInterfaceStyle.self]
    ) { (self: Self, _) in
      self.slotView.layer.borderColor = UIColor.n0.cgColor
    }
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
  public func configure(
    bookItem: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    startPage: Int = 0
  ) {
    ticketView.configure(
      bookItem: bookItem,
      departure: departure,
      destination: destination,
      startPage: startPage
    )
  }
  
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
      self.isPrintCompleted = true
      
      let finishGenerator = UINotificationFeedbackGenerator()
      finishGenerator.notificationOccurred(.success)
      
      self.enableTearIfNeeded()
      self.onPrintAnimationCompleted?()
    }
  }
}

// MARK: - Private
private extension TicketPrinterView {
  // 출력 상태 초기화, 찢기 애니메이션 상태 초기화
  // 분리된 아래 조각 스냅샷 제거
  func reset() {
    stopHaptics()
    // 찢기 힌트 애니메, 타이머 초기화
    stopHintAnimation()
    
    isPrintCompleted = false
    isTearing = false
    isTearCompleted = false
    tearProgressX = 0
    panStartProgressX = 0
    lastHapticProgress = 0
    
    panGesture.isEnabled = false
    
    cleanupBottomPiece()
    
    ticketView.isHidden = false
    ticketView.transform = .identity
    ticketView.layer.mask = nil
    
    revealHeightConstraint?.update(offset: 0)
    layoutIfNeeded()
  }
  
  // 찢기 기능이 활성화 되어 있으면 pan 제스처 활성화
  // isTearEnabled가 true인 경우에만 힌트 애니메이션 타이머 시작
  func enableTearIfNeeded() {
    guard isTearEnabled else { return }
    panGesture.isEnabled = true
    scheduleHintAnimation()
  }
  
  // 프린트 중 반복 햅틱 시작
  func startHaptics() {
    stopHaptics()
    hapticTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
      guard let self else { return }
      self.hapticGenerator.impactOccurred(intensity: 1.0)
      self.hapticGenerator.prepare()
    }
  }
  
  // 프린트 중 반복 햅틱 중지
  func stopHaptics() {
    hapticTimer?.invalidate()
    hapticTimer = nil
  }
  
  // 분리된 아래 스냅샷 제거하고 원본 티켓 마스크 초기화
  func cleanupBottomPiece() {
    bottomPieceView?.removeFromSuperview()
    bottomPieceView = nil
    ticketView.layer.mask = nil
  }
  
  // tearProgressX를 기준으로 찢기 UI 갱신
  // 1. 점선 아래 영역을 스냅샷으로 1회 생성
  // 2. 원본 티켓뷰는 점선 위쪽만 보이게 마스킹
  // 3. 아래 조각은 오른쪽 상단을 축으로 회전시켜 뜯기는 느낌
  func updateTearUI() {
    layoutIfNeeded()
    
    let ticketBounds = ticketView.bounds
    let width = ticketBounds.width
    let height = ticketBounds.height
    let tearY = height * tearLineYRatio
    
    let progressX = min(max(tearProgressX, 0), width)
    let normalized = progressX / width
    
    guard normalized > 0 else {
      cleanupBottomPiece()
      return
    }
    
    // 아래 조각 스냅샷은 최초 1회 생성
    if bottomPieceView == nil {
      let bottomRect = CGRect(x: 0, y: tearY, width: width, height: height - tearY)
      guard let snapshot = ticketView.resizableSnapshotView(
        from: bottomRect,
        afterScreenUpdates: false,
        withCapInsets: .zero
      ) else { return }
      
      // 오른쪽 위를 회전축으로
      // 오른쪽은 붙어있고, 왼쪽만 내려가는 느낌
      snapshot.layer.anchorPoint = CGPoint(x: 1, y: 0)
      snapshot.layer.position = CGPoint(
        x: ticketView.frame.maxX,
        y: ticketView.frame.minY + tearY
      )
      snapshot.bounds = CGRect(x: 0, y: 0, width: width, height: height - tearY)
      
      snapshot.layer.shadowColor = UIColor.black.cgColor
      revealContainerView.addSubview(snapshot)
      bottomPieceView = snapshot
      
      // 원본 티켓뷰는 점선 위쪽만 보이게 마스킹
      // 아래쪽은 스냅샷이 보여줌
      let topOnlyPath = UIBezierPath(
        rect: CGRect(x: 0, y: 0, width: width, height: tearY)
      )
      let topMask = CAShapeLayer()
      topMask.frame = ticketBounds
      topMask.path = topOnlyPath.cgPath
      topMask.fillRule = .nonZero
      ticketView.layer.mask = topMask
    }
    
    guard let piece = bottomPieceView else { return }
    
    // 진행도에 따라 아래 조각 더 많이 회전
    let rotation = -(normalized * 0.35)
    
    // 진행도에 비례해서 그림자 강하게
    piece.transform = CGAffineTransform(rotationAngle: rotation)
    piece.layer.shadowOpacity = Float(0.1 + normalized * 0.2)
    piece.layer.shadowRadius = 4 + normalized * 10
    piece.layer.shadowOffset = CGSize(width: -2, height: 4 + normalized * 8)
  }
  
  // 찢기 완료 애니메이션
  func animateTearCompletion() {
    guard let piece = bottomPieceView else {
      finalizeTear()
      return
    }
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred(intensity: 1.0)
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 0.82,
      initialSpringVelocity: 0.5,
      options: [.curveEaseIn]
    ) {
      piece.transform = CGAffineTransform(rotationAngle: -(0.7))
      piece.alpha = 0
    } completion: { _ in
      self.cleanupBottomPiece()
      
      let ticketBounds = self.ticketView.bounds
      let tearY = ticketBounds.height * self.tearLineYRatio
      let finalPath = UIBezierPath(
        rect: CGRect(x: 0, y: 0, width: ticketBounds.width, height: tearY)
      )
      let finalMask = CAShapeLayer()
      finalMask.frame = ticketBounds
      finalMask.path = finalPath.cgPath
      finalMask.fillRule = .nonZero
      self.ticketView.layer.mask = finalMask
      
      self.finalizeTear()
    }
  }
  
  // 찢기 완료 상태 확정
  func finalizeTear() {
    isTearCompleted = true
    panGesture.isEnabled = false
    onTearProgressChanged?(true)
    onTearCompleted?()
  }
}

// MARK: - Gesture
private extension TicketPrinterView {
  // 팬 제스처 처리 메소드
  @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    guard isTearEnabled, isPrintCompleted, !isTearCompleted else { return }
    
    let location = gesture.location(in: ticketView)
    let translation = gesture.translation(in: revealContainerView)
    
    switch gesture.state {
      // 점선 좌우 부근에서 시작했는지 검증
    case .began:
      guard canStartTear(at: location) else { return }
      isTearing = true
      panStartProgressX = tearProgressX
      tearHapticGenerator.prepare()
      // 사용자가 찢기 시작하면 힌트 애니메이션 중지함
      stopHintAnimation()
      
      // 좌우 translation을 진행도로 변환하고 ui 갱신함.
    case .changed:
      guard isTearing else { return }
      
      let maxWidth = ticketView.bounds.width
      let newProgress = max(
        0,
        min(maxWidth, panStartProgressX + max(0, translation.x))
      )
      
      updateTearProgress(newProgress)
      emitTearHapticIfNeeded(progress: newProgress)
      
      // 진행도 85이상이면 자동 완료
      let normalized = newProgress / maxWidth
      if normalized >= tearAutoCompleteRatio && !isTearCompleted {
        isTearing = false
        gesture.isEnabled = false
        gesture.isEnabled = true
        animateTearCompletion()
      }
      
      // 진행도가 임계치 이상이면 완료 애니메 실행
    case .ended, .cancelled, .failed:
      guard isTearing else { return }
      isTearing = false
      
      let normalized = tearProgressX / ticketView.bounds.width
      if normalized >= tearAutoCompleteRatio {
        animateTearCompletion()
      }
      
    default:
      break
    }
  }
  
  // 찢기 애니메 시작 가능 여부 확인
  // 사용자가 점선 근처에서 제스처를 시작했을때만 트루 반환함.
  func canStartTear(at location: CGPoint) -> Bool {
    let tearY = ticketView.bounds.height * tearLineYRatio
    return abs(location.y - tearY) <= tearActivationInset
  }
  
  // 찢기 진행도 갱신하고 ui 업데이트
  func updateTearProgress(_ progress: CGFloat) {
    guard progress != tearProgressX else { return }
    tearProgressX = progress
    updateTearUI()
  }
  
  // 진행도 차이가 일정 간격 이상일 때만 찢기 햅틱 발생
  func emitTearHapticIfNeeded(progress: CGFloat) {
    guard progress > 0 else { return }
    guard progress - lastHapticProgress >= hapticStep else { return }
    lastHapticProgress = progress
    tearHapticGenerator.impactOccurred(intensity: 0.7)
    tearHapticGenerator.prepare()
  }
}

// MARK: - HintAnimation
private extension TicketPrinterView {
  // 2초 후 힌트 애니메이션 예약
  // 사용자가 스스로 찢기를 시작하면 타이머는 취소됨
  func scheduleHintAnimation() {
    hintAnimationTimer?.invalidate()
    hintAnimationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
      self?.startHintAnimation()
    }
  }
  
  // 힌트 원형 뷰를 찢기 선 위에서 오른쪽으로 슥 미는 애니메이션 반복 실행
  func startHintAnimation() {
    guard !isTearCompleted else { return }
    
    let ticketFrame = ticketView.frame
    let tearY = ticketFrame.minY + ticketView.bounds.height * tearLineYRatio
    
    let startX = ticketFrame.minX + 24
    let endX = ticketFrame.maxX - 24
    
    hintView.center = CGPoint(x: startX, y: tearY)
    hintView.alpha = 0
    hintView.transform = .identity
    
    UIView.animateKeyframes(
      withDuration: 2.0,
      delay: 0,
      options: [.repeat],
      animations: {
        // 페이드인
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.15) {
          self.hintView.alpha = 1
        }
        // 오른쪽으로 이동
        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.6) {
          self.hintView.center = CGPoint(x: endX, y: tearY)
        }
        // 페이드아웃
        UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
          self.hintView.alpha = 0
        }
      }
    )
  }
  
  // 힌트 애니메이션 중지 및 초기 상태로 리셋
  // 사용자가 찢기 제스처를 시작하거나 reset() 호출 시 사용
  func stopHintAnimation() {
    hintAnimationTimer?.invalidate()
    hintAnimationTimer = nil
    hintView.layer.removeAllAnimations()
    hintView.alpha = 0
    
    // 시작 위치로 리셋
    let ticketFrame = ticketView.frame
    let tearY = ticketFrame.minY + ticketView.bounds.height * tearLineYRatio
    hintView.center = CGPoint(x: ticketFrame.minX + 24, y: tearY)
  }
}
