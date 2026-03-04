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
  
  func resized(to size: CGSize) -> UIImage {
    let rendered = UIGraphicsImageRenderer(size: size).image { _ in
      draw(in: CGRect(origin: .zero, size: size))
    }
    return rendered.withRenderingMode(renderingMode)
  }
}
