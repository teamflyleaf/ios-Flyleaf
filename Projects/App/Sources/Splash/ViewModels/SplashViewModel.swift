//
//  SplashViewModel.swift
//  App
//
//  Created by 여성일 on 5/30/26.
//

import AuthInterface
import Foundation

final class SplashViewModel {
  private let authService: AuthServicing
  
  init(authService: AuthServicing) {
    self.authService = authService
  }
  
  var onStepChanged: ((SplashLoadingStep) -> Void)?
  var onCompleted: ((SplashResult) -> Void)?
  
  func startLoading() async {
    onStepChanged?(.checkingAuth)
    
    if isFirstLaunch() {
      onCompleted?(.needsLogin)
      return
    }
    
    guard authService.isSignedIn else {
      onCompleted?(.needsLogin)
      return
    }
    
    // 케이스 3 추후 구현
  }
}

// MARK: - Private
private extension SplashViewModel {
  func isFirstLaunch() -> Bool {
    let key = "hasLaunchedBefore"
    if UserDefaults.standard.bool(forKey: key) {
      return false
    }
    UserDefaults.standard.set(true, forKey: key)
    return true
  }
}
