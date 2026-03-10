//
//  FlightAnnotationView.swift
//  Home
//
//  Created by 여성일 on 3/10/26.
//

import MapKit
import Then
import UIKit

/// 비행기 마커를 표시하는 커스텀 `MKAnnotationView` 입니다.
final class FlightAnnotationView: MKAnnotationView {
  static let identifier = "FlightAnnotationView"
  
  // MARK: - UI
  private let imageView = UIImageView().then {
    $0.image = .airplane
    $0.tintColor = .n0
  }
  
  override init(
    annotation: MKAnnotation?,
    reuseIdentifier: String?
  ) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.transform = .identity
  }
  
  // MARK: - Public Method
  func setRotation(_ angle: CGFloat) {
    imageView.transform = CGAffineTransform(rotationAngle: angle)
  }
}

// MARK: - Private
private extension FlightAnnotationView {
  func configureUI() {
    frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    backgroundColor = .clear
    canShowCallout = false

    addSubview(imageView)
    imageView.frame = bounds
  }
}
