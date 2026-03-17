//
//  CTAButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/5/26.
//

import UIKit

/// 앱 전역에서 사용하는 CTA 버튼 컴포넌트 입니다.
///
/// ```swift
/// let button = CTAButton(title: "다음")
/// button.isEnabled = true
/// ```
///
/// - Note:
///   - Auto Layout 사용 시 별도의 height 제약 없이 intrinsicContentSize를 통해 높이가 결정됩니다.
///   - width는 `noIntrinsicMetric`이므로 반드시 제약으로 설정해야 합니다.
///   - 높이 52로 고정입니다.
///   - 활성 상태: `.key0` 배경 + `.n0` 텍스트
///   - 비활성 상태: `.n10` 배경 + `.n30` 텍스트
public final class CTAButton: UIButton {
  // 기본 높이 설정: 52
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 52)
  }
  
  public override var isEnabled: Bool {
    didSet { updateAppearance() }
  }
  
  /// - Parameter title: 버튼에 표시할 텍스트
  public init(title: String) {
    super.init(frame: .zero)
    configure(title: title)
    updateAppearance()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private
private extension CTAButton {
  func configure(title: String) {
    setTitle(title, for: .normal)
    titleLabel?.font = .b1_sb
    
    layer.cornerRadius = 12
    clipsToBounds = true
  }
  
  // `isEnable` 상태에 따라 버튼 스타일 업데이트
  func updateAppearance() {
    setTitleColor(isEnabled ? .n0 : .n30, for: .normal)
    backgroundColor = isEnabled ? .key0 : .n10
  }
}
