//
//  GradientOverlayView.swift
//  Home
//
//  Created by 여성일 on 3/9/26.
//

import UIKit

/// MapView에 적용할 GradientOverlayView 입니다.
final class GradientOverlayView: UIView {
  private let gradientLayer = CAGradientLayer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    isUserInteractionEnabled = false
    backgroundColor = .clear
    
    configureGradient()
    layer.addSublayer(gradientLayer)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = bounds
  }
}

// MARK: - Private
private extension GradientOverlayView {
  func configureGradient() {
    gradientLayer.colors = [
      UIColor.n70.withAlphaComponent(0.85).cgColor,
      UIColor.n70.withAlphaComponent(0.05).cgColor,
      UIColor.n70.withAlphaComponent(0).cgColor
    ]
    
    gradientLayer.locations = [0.20, 0.50, 1.0]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
  }
}
