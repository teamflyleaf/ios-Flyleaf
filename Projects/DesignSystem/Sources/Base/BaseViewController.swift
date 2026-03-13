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
    
    setupKeyboardDismiss()
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
  
  /// 기본 확인 Alert을 표시합니다.
  ///
  /// 기본적으로 "확인" 버튼 하나만 포함된 Alert을 표시하며,
  /// 필요할 경우 확인 버튼 탭 시 실행할 액션을 전달할 수 있습니다.
  ///
  /// - Parameters:
  ///   - title: Alert의 제목
  ///   - message: Alert에 표시할 메시지
  ///   - confirmTitle: 확인 버튼의 제목 (기본값: "확인")
  ///   - onConfirm: 확인 버튼 탭 시 실행할 클로저
  public func presentAlert(
    title: String,
    message: String,
    confirmTitle: String = "확인"
  ) {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    
    let confirmAction = UIAlertAction(
      title: confirmTitle,
      style: .default
    )
    
    alert.addAction(confirmAction)
    
    present(alert, animated: true)
  }
}

// MARK: - Keyboard
private extension BaseViewController {
  func setupKeyboardDismiss() {
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboard)
    )
    
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
