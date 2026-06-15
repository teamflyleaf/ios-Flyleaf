//
//  SplashViewModel.swift
//  App
//
//  Created by 여성일 on 5/30/26.
//

import AuthInterface
import Foundation
import ReadingJourneyInterface

final class SplashViewModel {
  private let authService: AuthServicing
  private let readingJourneyService: ReadingJourneyServicing
  private let minimumDisplayDuration: Duration

  init(
    authService: AuthServicing,
    readingJourneyService: ReadingJourneyServicing,
    minimumDisplayDuration: Duration = .seconds(1.5)
  ) {
    self.authService = authService
    self.readingJourneyService = readingJourneyService
    self.minimumDisplayDuration = minimumDisplayDuration
  }

  var onStepChanged: ((SplashLoadingStep) -> Void)?
  var onCompleted: ((SplashResult) -> Void)?
  var onError: ((String) -> Void)?

  func startLoading() async {
    onStepChanged?(.checkingAuth)
    try? await Task.sleep(for: minimumDisplayDuration)

    let firstLaunch = isFirstLaunch()

    if firstLaunch {
      onCompleted?(.needsOnboarding)
      return
    }

    guard authService.isSignedIn else {
      onCompleted?(.needsLogin)
      return
    }

    onStepChanged?(.fetchingData)

    do {
      let journeys = try await readingJourneyService.fetchReadingJourneys()
      onCompleted?(.readyToMain(journeys))
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "여행 데이터를 불러오지 못했습니다."
      onError?(message)
      onCompleted?(.readyToMain([]))
    }
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
  
  // 테스트용 메소드
//  func isFirstLaunch() -> Bool {
//    let key = "hasLaunchedBefore"
//    UserDefaults.standard.set(false, forKey: key)  // 테스트용
//    if UserDefaults.standard.bool(forKey: key) {
//      return false
//    }
//    UserDefaults.standard.set(true, forKey: key)
//    return true
//  }
}
