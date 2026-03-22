//
//  JourneyProgressButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/21/26.
//

import Core
import UIKit
import SnapKit
import Then

/// 원형 버튼과 하단 타이틀로 구성된 Journey 전용 버튼 컴포넌트입니다.
///
/// ```swift
/// let button = JourneyProgressButton()
/// button.configure(
///   airport: airport,
///   book: book,
///   currentPage: 40
/// )
/// ```
///
/// - Note:
///   - 내부 원형 버튼 크기는 60x60 고정입니다.
///   - 진행률 원형 border(track/progress)는 버튼 바깥으로 4pt 확장되어 그려집니다.
///   - 하단에는 공항 IATA 코드와 책 제목을 표시합니다.
///   - 버튼과 타이틀 간 간격은 10pt 입니다.
///   - 진행률은 `currentPage / itemPage` 기준으로 계산됩니다.
public final class JourneyProgressButton: BaseView {
  private let circleSize: CGFloat = 60
  private let progressInset: CGFloat = 4
  private let titleSpacing: CGFloat = 10
  
  public override var intrinsicContentSize: CGSize {
    let progressDiameter = circleSize + (progressInset * 2)
    return CGSize(
      width: progressDiameter,
      height: progressDiameter + titleSpacing + titleLabel.intrinsicContentSize.height
    )
  }
  
  // 선택 상태 업데이트를 위한 변수
  public var isSelectedState: Bool = false {
    didSet {
      updateSelectionAppearance(animated: true)
    }
  }
  
  // MARK: - UI
  private let circleContainerView = UIView().then {
    $0.backgroundColor = .key0
    $0.layer.cornerRadius = 30
    $0.clipsToBounds = true
  }
  
  private let imageView = UIImageView().then {
    $0.image = .landing.resized(24, 24)
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .n0
  }
  
  private let iataLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n0
    $0.textAlignment = .center
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n0
    $0.textAlignment = .center
    $0.numberOfLines = 1
    $0.lineBreakMode = .byTruncatingTail
    $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
  
  /// 전체 원형 border 트랙
  private let trackLayer = CAShapeLayer()
  
  /// 진행률만큼 채워지는 progress ring
  private let progressLayer = CAShapeLayer()
  
  public override func configureUI() {
    [
      circleContainerView,
      titleLabel,
    ].forEach {
      addSubview($0)
    }
    
    circleContainerView.addSubview(imageView)
    circleContainerView.addSubview(iataLabel)
    
    layer.addSublayer(trackLayer)
    layer.addSublayer(progressLayer)
    
    setupProgressLayerStyle()
  }
  
  public override func setupLayout() {
    circleContainerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(progressInset)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(circleSize)
    }
    
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(20)
    }
    
    iataLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(2)
      $0.centerX.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(circleContainerView.snp.bottom).offset(titleSpacing)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(circleSize + (progressInset * 2))
    }
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    updateProgressPath()
  }
  
  // MARK: - Public Method
  public func configure(
    airport: AirportInfo,
    book: BookInfo,
    currentPage: Int
  ) {
    titleLabel.text = book.title
    iataLabel.text = airport.iata
    
    let totalPage = max(book.itemPage, 1)
    let progress = min(max(CGFloat(currentPage) / CGFloat(totalPage), 0), 1)
    updateProgress(progress: progress)
    
    invalidateIntrinsicContentSize()
  }
}

// MARK: - Private
private extension JourneyProgressButton {
  func setupProgressLayerStyle() {
    trackLayer.fillColor = UIColor.clear.cgColor
    trackLayer.strokeColor = UIColor.n40.cgColor
    trackLayer.lineWidth = 3
    trackLayer.lineCap = .round
    
    progressLayer.fillColor = UIColor.clear.cgColor
    progressLayer.strokeColor = UIColor.key0.cgColor
    progressLayer.lineWidth = 3
    progressLayer.lineCap = .round
    progressLayer.strokeEnd = 0
  }
  
  func updateProgressPath() {
    let circleFrame = circleContainerView.frame
    guard circleFrame != .zero else { return }
    
    let progressRect = circleFrame.insetBy(dx: -progressInset, dy: -progressInset)
    let center = CGPoint(x: progressRect.midX, y: progressRect.midY)
    
    let lineInset = trackLayer.lineWidth / 2
    let radius = (progressRect.width / 2) - lineInset
    
    let startAngle = -CGFloat.pi / 2
    let endAngle = startAngle + (CGFloat.pi * 2)
    
    let path = UIBezierPath(
      arcCenter: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: true
    )
    
    trackLayer.frame = bounds
    trackLayer.path = path.cgPath
    
    progressLayer.frame = bounds
    progressLayer.path = path.cgPath
  }
  
  func updateProgress(progress: CGFloat) {
    // 프로그레스 변경 애니메이션 끄기
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    progressLayer.strokeEnd = progress
    CATransaction.commit()
  }
  
  func updateSelectionAppearance(animated: Bool) {
    let changes = {
      self.titleLabel.textColor = self.isSelectedState ? .key0 : .n0
    }
    
    if animated {
      UIView.animate(withDuration: 0.2) {
        changes()
      }
    } else {
      changes()
    }
  }
}
