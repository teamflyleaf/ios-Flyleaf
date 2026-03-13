//
//  +UITextField.swift
//  DesignSystem
//
//  Created by 여성일 on 3/13/26.
//

import UIKit

public extension UITextField {
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
