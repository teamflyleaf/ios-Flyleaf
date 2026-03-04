//
//  +UIFont.swift
//  DesignSystem
//
//  Created by 여성일 on 3/5/26.
//

import UIKit

public extension UIFont {
  enum Pretendard {
    case semibold, bold, regular, medium
    
    fileprivate var convertible: DesignSystemFontConvertible {
      switch self {
      case .semibold: DesignSystemFontFamily.Pretendard.semiBold
      case .bold: DesignSystemFontFamily.Pretendard.bold
      case .regular: DesignSystemFontFamily.Pretendard.regular
      case .medium: DesignSystemFontFamily.Pretendard.medium
      }
    }
  }
  
  /// Pretendard UIFont 생성
  static func pretendard(type: UIFont.Pretendard, size: CGFloat) -> UIFont {
    type.convertible.font(size: size)
  }
  
  // MARK: - Heading
  static let h1 = pretendard(type: .semibold, size: 28)
  static let h2 = pretendard(type: .bold, size: 24)
  static let h3 = pretendard(type: .bold, size: 20)
  static let h4_sb = pretendard(type: .semibold, size: 18)
  static let h4_m = pretendard(type: .medium, size: 18)
  
  // MARK: - Body
  static let b1_sb = pretendard(type: .semibold, size: 16)
  static let b1_m = pretendard(type: .medium, size: 16)
  static let b2_sb = pretendard(type: .semibold, size: 14)
  static let b2_m = pretendard(type: .medium, size: 14)
  
  // MARK: - Caption
  static let c1 = pretendard(type: .regular, size: 16)
  static let c2 = pretendard(type: .regular, size: 14)
  static let c3 = pretendard(type: .regular, size: 12)
}
