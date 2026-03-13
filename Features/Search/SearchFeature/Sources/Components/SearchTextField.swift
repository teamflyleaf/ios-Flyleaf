//
//  SearchTextField.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

import UIKit

public final class SearchTextField: UITextField {
  var textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: textInsets)
  }
  
  public override func editingRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: textInsets)
  }
  
  public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    bounds.inset(by: textInsets)
  }
  
  /// 텍스트필드의 placeholder 텍스트와 색상을 설정합니다.
  /// - Parameters:
  ///   - text: 표시할 placeholder 문자열
  ///   - color: placeholder 텍스트 색상
  func setPlaceholder(_ text: String, color: UIColor) {
    attributedPlaceholder = NSAttributedString(
      string: text,
      attributes: [.foregroundColor: color]
    )
  }
}

// MARK: - Private
private extension SearchTextField {
  func configureUI() {
    clearButtonMode = .whileEditing // clear 버튼
    returnKeyType = .search
  }
}
