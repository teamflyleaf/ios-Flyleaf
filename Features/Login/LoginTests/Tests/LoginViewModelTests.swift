//
//  LoginViewModelTests.swift
//  Login
//
//  Created by 여성일 on 3/7/26.
//

import XCTest
@testable import LoginFeature

final class LoginViewModelTests: XCTestCase {
  /// LoginViewModel 이벤트 성공 테스트
  func test_handleLoginSuccess_callsOnLoginSuccess() {
    let viewModel = LoginViewModel()
    var didCall = false
    
    viewModel.onLoginSuccess = {
      didCall = true
    }
    
    viewModel.handleLoginSuccess()
    
    XCTAssertTrue(didCall)
  }
}
