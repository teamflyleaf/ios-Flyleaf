//
//  MockAuthService.swift
//  App
//
//  Created by 여성일 on 5/31/26.
//

import AuthInterface
import Core

final class MockAuthService: AuthServicing {
  var isSignedIn: Bool = false
  var currentUser: AppUser? = nil
  
  var signInResult: Result<AppUser, Error> = .success(
    AppUser(id: "1", name: "테스트", email: "test@test.com")
  )
  
  func signInWithApple(payload: AppleLoginPayload) async throws -> AppUser {
    switch signInResult {
    case .success(let user):
      return user
    case .failure(let error):
      throw error
    }
  }
  
  func signOut() throws {}

  func deleteAccount() async throws {}
}
