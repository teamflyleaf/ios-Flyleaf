//
//  LoginViewModelTests.swift
//  Login
//
//  Created by 여성일 on 3/7/26.
//

import XCTest
@testable import Core
@testable import LoginFeature
@testable import LoginTesting

final class LoginViewModelTests: XCTestCase {
  /*
   Apple 로그인 성공 시 ViewModel이 `onLoginSuccess` 콜백을 호출하는지 검증하는 테스트
   - Given: 로그인에 성공하도록 설정된 `MockAuthService`
   - When: `handleAppleAuthorization(payload:)` 호출
   - Then: `onLoginSuccess`가 호출되고 전달된 `User` 정보가 올바른지 확인합니다.
   */
  func test_handleAppleAuthorization_success_callsOnLoginSuccess() async {
    // Mock, ViewModel 생성
    let mockAuthService = MockAuthService()
    let viewModel = LoginViewModel(authService: mockAuthService)
    
    var receivedUser: User?
    var failureMessage: String?
    
    // 성공 콜백 등록
    viewModel.onLoginSuccess = { user in
      receivedUser = user
    }
    
    // 실패 콜백 등록
    viewModel.onLoginFailure = { message in
      failureMessage = message
    }
    
    // Mock Payload 생성
    let payload = AppleLoginPayload(
      idToken: "mock-id-token",
      rawNonce: "mock-raw-nonce",
      name: "테스트",
      email: "test@test.com"
    )
    
    // 테스트 대상 실행
    await viewModel.handleAppleAuthorization(payload: payload)
    
    XCTAssertNil(failureMessage)
    XCTAssertEqual(receivedUser?.id, "1")
    XCTAssertEqual(receivedUser?.name, "테스트")
    XCTAssertEqual(receivedUser?.email, "test@test.com")
  }
  
  /*
   Apple 로그인 성공 시 ViewModel이 `onLoginFailure` 콜백을 호출하는지 검증하는 테스트
   - Given: 로그인 실패를 반환하도록 설정된 `MockAuthService`
   - When: `handleAppleAuthorization(payload:)` 호출
   - Then: `onLoginSuccess`는 호출되지 않고 `onLoginFailure`가 호출되는지 확인합니다.
   */
  func test_handleAppleAuthorization_failure_callsOnLoginFailure() async {
    // Mock, ViewModel 생성
    let mockAuthService = MockAuthService()
    // 의도적으로 실패
    mockAuthService.signInResult = .failure(MockAuthError.failed)
    
    let viewModel = LoginViewModel(authService: mockAuthService)
    
    var receivedUser: User?
    var failureMessage: String?
    
    // 성공 콜백 등록
    viewModel.onLoginSuccess = { user in
      receivedUser = user
    }
    
    // 실패 콜백 등록
    viewModel.onLoginFailure = { message in
      failureMessage = message
    }
    
    // Mock Payload 생성
    let payload = AppleLoginPayload(
      idToken: "mock-id-token",
      rawNonce: "mock-raw-nonce",
      name: "테스트",
      email: "test@test.com"
    )
    
    // 테스트 대상 실행
    await viewModel.handleAppleAuthorization(payload: payload)
    
    XCTAssertNil(receivedUser)
    XCTAssertEqual(failureMessage, "로그인에 실패했어요.")
  }
}
