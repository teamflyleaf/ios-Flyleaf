//
//  NeutralTextField.swift
//  DesignSystem
//
//  Created by 여성일 on 3/13/26.
//

import UIKit

/// 내부 여백(inset)을 지원하는 UITextField 서브클래스입니다.
///
/// 텍스트, 플레이스홀더, 편집 영역 모두 동일한 inset이 적용되어 있습니다.
///
/// ```swift
/// let textField = NeutralTextField()
/// textField.placeholder = "검색어를 입력하세요"
/// ```
///
/// - Note:
///   - 기본적으로 좌우 10pt 패딩이 적용됩니다.
///   - 편집 중에는 clear 버튼이 자동으로 표시됩니다.
public final class NeutralTextField: UITextField {
  var textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  // 텍스트 표시 영역에 inset 적용
  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: textInsets)
  }
  
  // 편집 중 텍스트 입력 영역에 inset 적용
  public override func editingRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: textInsets)
  }
  
  // 플레이스홀더 표시 영역에 inset 적용
  public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: textInsets)
  }
}

// MARK: - Private
private extension NeutralTextField {
  func configureUI() {
    // 입력 중일 때만 clear 버튼 표시
    clearButtonMode = .whileEditing
  }
}
