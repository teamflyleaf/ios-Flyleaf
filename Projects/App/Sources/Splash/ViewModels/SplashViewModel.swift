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
  private let minimumDisplayDuration: Duration

  init(
    authService: AuthServicing,
    minimumDisplayDuration: Duration = .seconds(1.5)
  ) {
    self.authService = authService
    self.minimumDisplayDuration = minimumDisplayDuration
  }

  var onStepChanged: ((SplashLoadingStep) -> Void)?
  var onCompleted: ((SplashResult) -> Void)?

  func startLoading() async {
    onStepChanged?(.checkingAuth)
    try? await Task.sleep(for: minimumDisplayDuration)

    if isFirstLaunch() {
      onCompleted?(.needsLogin)
      return
    }

    guard authService.isSignedIn else {
      onCompleted?(.needsLogin)
      return
    }

    onCompleted?(.readyToMain)
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
