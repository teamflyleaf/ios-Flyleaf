//
//  SettingViewModel.swift
//  Setting
//
//  Created by 여성일 on 4/23/26.
//

import AuthInterface

public final class SettingViewModel {
  private let authService: AuthServicing
  
  var onLogoutSuccess: (() -> Void)?
  var onError: ((Error) -> Void)?
  var onDeleteAccountSuccess: (() -> Void)?
  var onRequiresRecentLogin: (() -> Void)?
  
  var currentEmail: String? {
    authService.currentUser?.email
  }
  
  public init(authService: AuthServicing) {
    self.authService = authService
  }
  
  public func logout() {
    do {
      try authService.signOut()
      onLogoutSuccess?()
    } catch {
      onError?(error)
    }
  }
  
  @MainActor
  public func deleteAccount() {
    Task {
      do {
        try await authService.deleteAccount()
        onDeleteAccountSuccess?()
      } catch AuthError.requiresRecentLogin {
        onRequiresRecentLogin?()  // 구분 처리
      } catch {
        onError?(error)
      }
    }
  }
}
