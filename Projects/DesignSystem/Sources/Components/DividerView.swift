//
//  DividerView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/12/26.
//

import UIKit
import Then

public final class DividerView: BaseView {
  private let color: UIColor
  private let weight: CGFloat
  
  public init(
    color: UIColor = .n0.withAlphaComponent(0.1),
    weight: CGFloat = 1
  ) {
    self.color = color
    self.weight = weight
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: weight)
  }
  
  public override func configureUI() {
    backgroundColor = color
  }
}
