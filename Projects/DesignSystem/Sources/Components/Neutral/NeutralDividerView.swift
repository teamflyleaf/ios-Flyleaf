//
//  DividerView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/12/26.
//

import UIKit
import Then

/// 화면을 구분하기 Divider 컴포넌트 입니다.
///
/// 기본적으로 전체 너비를 차지하며, 높이는 `weight` 값으로 결정됩니다.
///
/// ```swift
/// let divider = DividerView()
///
/// let thickDivider = DividerView(
///   color: .n0.withAlphaComponent(0.2),
///   weight: 2
/// )
/// ```
///
/// - Note:
///   - Auto Layout 사용 시 별도의 height 제약 없이 intrinsicContentSize를 통해 높이가 결정됩니다.
///   - width는 `noIntrinsicMetric`이므로 반드시 제약으로 설정해야 합니다.
public final class DividerView: BaseView {
  private let color: UIColor
  private let weight: CGFloat
  
  /// - Parameters:
  ///   - color: 디바이더의 색상 (기본값: `.l1`)
  ///   - weight: 디바이더의 두께 (기본값: `1`)
  public init(
    color: UIColor = .l1,
    weight: CGFloat = 1
  ) {
    self.color = color
    self.weight = weight
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // 기본 높이 설정: weight값
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: weight)
  }
  
  public override func configureUI() {
    backgroundColor = color
  }
}
