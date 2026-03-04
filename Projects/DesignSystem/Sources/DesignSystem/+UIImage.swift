//
//  +UIImage.swift
//  DesignSystem
//
//  Created by 여성일 on 3/5/26.
//

import UIKit

public extension UIImage {
  // MARK: - Neutral
  static let book = DesignSystemAsset.book.image.withRenderingMode(.alwaysTemplate)
  static let pen = DesignSystemAsset.pen.image.withRenderingMode(.alwaysTemplate)
  static let plus = DesignSystemAsset.plus.image.withRenderingMode(.alwaysTemplate)
  static let right = DesignSystemAsset.right.image.withRenderingMode(.alwaysTemplate)
  static let search = DesignSystemAsset.search.image.withRenderingMode(.alwaysTemplate)
  static let time = DesignSystemAsset.time.image.withRenderingMode(.alwaysTemplate)
  static let xmark = DesignSystemAsset.x.image.withRenderingMode(.alwaysTemplate)
  
  // MARK: - Chevron
  static let chevronLeft = DesignSystemAsset.chevronLeft.image.withRenderingMode(.alwaysTemplate)
  static let chevronRight = DesignSystemAsset.chevronRight.image.withRenderingMode(.alwaysTemplate)

  // MARK: - Airplane
  static let airplane = DesignSystemAsset.airplane.image.withRenderingMode(.alwaysTemplate)
  static let landing = DesignSystemAsset.landing.image.withRenderingMode(.alwaysTemplate)
  static let takeOff = DesignSystemAsset.takeOff.image.withRenderingMode(.alwaysTemplate)
  
  // MARK: - Public Method
  /// UIImage의 크기를 지정한 width, height로 리사이즈하여 새로운 이미지를 반환합니다.
  ///
  /// 기존 이미지의 `renderingMode`를 유지하여 template 이미지의 경우 `tintColor`가 정상적으로 적용됩니다.
  ///
  /// - Parameters:
  ///   - width: 변경할 이미지의 너비 (pt 단위)
  ///   - height: 변경할 이미지의 높이
  /// - Returns: 지정한 크기로 리사이즈된 `UIImage`
  ///
  /// Example:
  /// ```swift
  /// let icon = UIImage.takeOff.resized(24, 24)
  /// button.setImage(icon, for: .normal)
  /// button.tintColor = .key0
  /// ```
  func resized(_ width: Int, _ height: Int) -> UIImage {
    let size = CGSize(width: width, height: height)
    let rendered = UIGraphicsImageRenderer(size: size).image { _ in
      draw(in: CGRect(origin: .zero, size: size))
    }
    return rendered.withRenderingMode(renderingMode)
  }
}
