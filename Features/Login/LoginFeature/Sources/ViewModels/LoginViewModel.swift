//
//  LoginViewModel.swift
//  Login
//
//  Created by 여성일 on 3/6/26.
//

import AuthInterface
import Core

public final class LoginViewModel {
  private let authService: AuthServicing
  
  public init(authService: AuthServicing) {
    self.authService = authService
  }
  
  var onLoginSuccess: ((AppUser) -> Void)?
  var onLoginFailure: ((String) -> Void)?
  var onLoadingChanged: ((Bool) -> Void)?
  
  @MainActor
  func handleAppleAuthorization(
    payload: AppleLoginPayload
  ) async {
    onLoadingChanged?(true)
    defer { onLoadingChanged?(false) }
    
    do {
      let user = try await authService.signInWithApple(payload: payload)
      onLoginSuccess?(user)
    } catch {
      onLoginFailure?("로그인에 실패했어요.")
    }
  }
}
