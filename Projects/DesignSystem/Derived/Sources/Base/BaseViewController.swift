//
//  BaseViewController.swift
//  DesignSystem
//
//  Created by 여성일 on 3/5/26.
//

import UIKit

open class BaseViewController: UIViewController {

  open override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .bg0
    configureUI()
    setupLayout()
    bind()
  }
  
  /// ViewController의 UI 요소를 생성하고 기본 속성을 설정합니다.
  ///
  /// `addSubview` 등을 통해 뷰 계층을 구성합니다.
  ///
  /// `viewDidLoad()`에서 가장 먼저 호출됩니다.
  open func configureUI() {}


  /// UI 요소의 Auto Layout 제약조건을 설정합니다.
  ///
  /// `configureUI()` 이후 호출됩니다.
  open func setupLayout() {}


  /// UI 이벤트와 데이터 바인딩을 설정합니다.
  ///
  /// 사용자 인터랙션 또는 데이터 흐름을 연결할 때 사용됩니다.
  ///
  /// `setupLayout()` 이후 호출됩니다.
  open func bind() {}
}
