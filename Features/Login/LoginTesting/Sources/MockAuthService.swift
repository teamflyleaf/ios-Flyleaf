//
//  MockAuthService.swift
//  Login
//
//  Created by 여성일 on 3/8/26.
//

import AuthenticationServices
import Core

final class MockAuthService: AuthServicing {
  var isSignedIn: Bool = false
  
  var signInResult: Result<User, Error> = .success(
    User(id: "1", name: "테스트", email: "test@test.com")
  )
  
  func signInWithApple(
    payload: AppleLoginPayload
  ) async throws -> User {
    switch signInResult {
    case .success(let user):
      return user
    case .failure(let error):
      throw error
    }
  }
}
