//
//  LoginViewModel.swift
//  Login
//
//  Created by 여성일 on 3/6/26.
//

import AuthenticationServices
import Core

public final class LoginViewModel {
  private let authService: AuthServicing
  
  public init(authService: AuthServicing) {
    self.authService = authService
  }
  
  var onLoginSuccess: ((User) -> Void)?
  var onLoginFailure: ((String) -> Void)?
  
  func handleAppleAuthorization(
    _ credential: ASAuthorizationAppleIDCredential,
    rawNonce: String
  ) {
    Task {
      do {
        let user = try await authService.signInWithApple(credential: credential, rawNonce: rawNonce)
        onLoginSuccess?(user)
      } catch {
        onLoginFailure?("로그인에 실패했어요.")
      }
    }
  }
}
