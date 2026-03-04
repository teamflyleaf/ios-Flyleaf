//
//  BaseView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/5/26.
//

import UIKit

open class BaseView: UIView {

  public override init(frame: CGRect) {
      super.init(frame: frame)
      self.configureUI()
      self.setupLayout()
  }
  
  public required init?(coder: NSCoder) {
      super.init(coder: coder)
  }
  
  /// UI 요소를 생성하고 기본 속성을 설정합니다.
  ///
  /// 주로 `addSubview`를 통해 뷰 계층을 구성하고, 배경색/코너/기본 스타일 등을 지정합니다.
  open func configureUI() {}

  /// Auto Layout 제약조건을 설정합니다.
  ///
  /// `configureUI()` 이후 호출됩니다.
  open func setupLayout() {}
}
