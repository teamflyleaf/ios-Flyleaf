//
//  NeutralTextField.swift
//  DesignSystem
//
//  Created by 여성일 on 3/13/26.
//

import UIKit

public final class NeutralTextField: UITextField {
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
}

// MARK: - Private
private extension NeutralTextField {
  func configureUI() {
    clearButtonMode = .whileEditing // clear 버튼
  }
}
