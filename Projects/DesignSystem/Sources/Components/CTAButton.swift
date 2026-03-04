//
//  CTAButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/5/26.
//

import UIKit

public final class CTAButton: UIButton {
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 52)
  }
  
  public override var isEnabled: Bool {
    didSet { updateAppearance() }
  }
  public init(title: String) {
    super.init(frame: .zero)
    configure(title: title)
    updateAppearance()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private
private extension CTAButton {
  func configure(title: String) {
    setTitle(title, for: .normal)
    titleLabel?.font = .b1_sb
    
    layer.cornerRadius = 12
    clipsToBounds = true
  }
  
  func updateAppearance() {
    setTitleColor(isEnabled ? .n0 : .n30, for: .normal)
    backgroundColor = isEnabled ? .key0 : .n10
  }
}
