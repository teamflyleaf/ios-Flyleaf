//
//  NeutralPaddingLabel.swift
//  DesignSystem
//
//  Created by 여성일 on 3/16/26.
//

import UIKit

/// 내부 여백(inset)을 지원하는 UILabel 서브클래스입니다.
///
/// ```swift
/// let label = NeutralPaddingLabel()
/// label.text = "Flyleaf"
/// ```
///
/// - Note:
///   - `intrinsicContentSize`와 `sizeThatFits`를 오버라이드하여 Auto Layout 환경에서도
///     패딩이 적용된 크기로 정확하게 계산됩니다.
///   - `numberOfLines = 0` 설정 시 multiline에서도 정상 동작합니다.
public final class NeutralPaddingLabel: UILabel {
  // 텍스트 내부 여백 설정: 기본값 좌우 10, 상하 20
  public var textInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
  
  // 텍스트 그릴 때 inset 적용
  public override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: textInsets))
  }
  
  // 오토레이아웃 사용할 때 별도의 높이 계산 없이 패딩이 적용된 크기 제공하기 위한 변수 (intrinsicContentSize)
  public override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + textInsets.left + textInsets.right,
      height: size.height + textInsets.top + textInsets.bottom
    )
  }
}
