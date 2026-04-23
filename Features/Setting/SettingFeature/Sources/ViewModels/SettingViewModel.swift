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
}
