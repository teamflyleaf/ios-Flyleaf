//
//  NeutralTooltipView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/30/26.
//

import UIKit
import Then
import SnapKit

/// 말풍선 형태의 중립 스타일 툴팁 뷰입니다.
///
/// 안내 문구와 닫기 버튼을 함께 표시하며,
/// 꼬리 위치를 기준으로 다양한 방향의 툴팁을 표현할 수 있습니다.
///
/// 툴팁은 상단 또는 하단에 꼬리를 표시할 수 있으며,
/// 꼬리의 정렬 위치는 왼쪽, 가운데, 오른쪽 중 하나로 설정할 수 있습니다.
///
/// ```swift
/// let tooltipView = NeutralTooltipView(tailPosition: .bottomCenter)
/// tooltipView.configure(tip: "도움말을 확인해보세요.")
/// tooltipView.onTapClose = {
///   print("Tooltip closed")
/// }
/// ```
///
/// - Note:
/// `dismiss(completion:)`를 호출하면 페이드 아웃 애니메이션 후 `isHidden`이 `true`로 변경됩니다.
public final class NeutralTooltipView: BaseView {
  private let tailWidth: CGFloat = 10
  private let tailHeight: CGFloat = 6
  
  public enum TailPosition {
    case topLeft
    case topCenter
    case topRight
    case bottomLeft
    case bottomCenter
    case bottomRight
  }
  
  public var onTapClose: (() -> Void)?
  
  // MARK: - Private
  private var tailPosition: TailPosition = .bottomLeft
  private let tailLayer = CAShapeLayer()
  
  private let bubbleView = UIView().then {
    $0.backgroundColor = .key0
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
  }
  
  private let tipLabel = UILabel().then {
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
    $0.textAlignment = .left
  }
  
  private let closeButton = UIButton().then {
    $0.setImage(.xmark, for: .normal)
    $0.tintColor = .n0
  }
  
  /// `NeutralTooltipView`를 생성합니다.
  ///
  /// - Parameter tailPosition: 툴팁 꼬리의 위치입니다. 기본값은 `bottomLeft`입니다.
  public init(tailPosition: TailPosition = .bottomLeft) {
    self.tailPosition = tailPosition
    super.init(frame: .zero)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func configureUI() {
    backgroundColor = .clear
    
    tailLayer.fillColor = UIColor.key0.cgColor
    tailLayer.strokeColor = UIColor.clear.cgColor
    layer.addSublayer(tailLayer)
    
    addSubview(bubbleView)
    [tipLabel, closeButton].forEach { bubbleView.addSubview($0) }
    
    closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
  }
  
  public override func setupLayout() {
    switch tailPosition {
    case .topLeft, .topCenter, .topRight:
      bubbleView.snp.makeConstraints {
        $0.top.equalToSuperview().offset(tailHeight)
        $0.horizontalEdges.bottom.equalToSuperview()
      }
      
    case .bottomLeft, .bottomCenter, .bottomRight:
      bubbleView.snp.makeConstraints {
        $0.top.horizontalEdges.equalToSuperview()
        $0.bottom.equalToSuperview().inset(tailHeight)
      }
    }
    
    tipLabel.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview().inset(12)
      $0.leading.equalToSuperview().offset(12)
    }
    
    closeButton.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview().inset(12)
      $0.leading.equalTo(tipLabel.snp.trailing).offset(12)
      $0.trailing.equalToSuperview().inset(12)
      $0.width.height.equalTo(12)
    }
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    drawTail()
  }
  
  // MARK: - Public Method
  public func configure(tip: String) {
    tipLabel.text = tip
  }
  
  /// 툴팁을 페이드 아웃 애니메이션과 함께 숨깁니다.
  ///
  /// 애니메이션이 끝나면 `isHidden`을 `true`로 설정하고,
  /// 필요 시 completion 클로저를 호출합니다.
  ///
  /// - Parameter completion: 툴팁이 완전히 사라진 뒤 실행할 클로저입니다.
  public func dismiss(completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: 0.25, animations: {
      self.alpha = 0
    }, completion: { _ in
      self.isHidden = true
      self.alpha = 1
      completion?()
    })
  }
}

// MARK: - Tail Drawing
private extension NeutralTooltipView {
  func drawTail() {
    let totalWidth = bounds.width
    let totalHeight = bounds.height
    
    let tailMidX: CGFloat
    switch tailPosition {
    case .topLeft, .bottomLeft:
      tailMidX = 20
    case .topCenter, .bottomCenter:
      tailMidX = totalWidth / 2
    case .topRight, .bottomRight:
      tailMidX = totalWidth - 20
    }
    
    let path = UIBezierPath()
    
    switch tailPosition {
    case .topLeft, .topCenter, .topRight:
      path.move(to: CGPoint(x: tailMidX - tailWidth / 2, y: tailHeight))
      path.addLine(to: CGPoint(x: tailMidX, y: 0))
      path.addLine(to: CGPoint(x: tailMidX + tailWidth / 2, y: tailHeight))
      path.close()
      
    case .bottomLeft, .bottomCenter, .bottomRight:
      path.move(to: CGPoint(x: tailMidX - tailWidth / 2, y: totalHeight - tailHeight))
      path.addLine(to: CGPoint(x: tailMidX, y: totalHeight))
      path.addLine(to: CGPoint(x: tailMidX + tailWidth / 2, y: totalHeight - tailHeight))
      path.close()
    }
    
    tailLayer.path = path.cgPath
  }
}

// MARK: - Private
private extension NeutralTooltipView {
  @objc func didTapClose() {
    onTapClose?()
  }
}
