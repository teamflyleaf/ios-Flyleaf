//
//  SplashViewModelTests.swift
//  App
//
//  Created by 여성일 on 5/31/26.
//

import XCTest
@testable import FlyleafDev

final class SplashViewModelTests: XCTestCase {
  private var sut: SplashViewModel!
  private var mockAuthService: MockAuthService!

  override func setUp() {
    super.setUp()
    UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
    mockAuthService = MockAuthService()
    sut = SplashViewModel(
      authService: mockAuthService,
      minimumDisplayDuration: .seconds(0)
    )
  }

  override func tearDown() {
    UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
    sut = nil
    mockAuthService = nil
    super.tearDown()
  }

  /*
   최초 실행 시 needsLogin으로 라우팅되는지 검증하는 테스트

   - Given: 최초 실행 상태 (hasLaunchedBefore 없음)
   - When: startLoading() 호출
   - Then: onCompleted가 .needsLogin으로 호출되는지 확인합니다.
   */
  func test_startLoading_whenFirstLaunch_callsNeedsLogin() async {
    var receivedResult: SplashResult?
    sut.onCompleted = { receivedResult = $0 }

    await sut.startLoading()

    XCTAssertEqual(receivedResult, .needsLogin)
  }

  /*
   로그아웃 상태에서 needsLogin으로 라우팅되는지 검증하는 테스트

   - Given: 재방문 + 로그아웃 상태
   - When: startLoading() 호출
   - Then: onCompleted가 .needsLogin으로 호출되는지 확인합니다.
   */
  func test_startLoading_whenSignedOut_callsNeedsLogin() async {
    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    mockAuthService.isSignedIn = false

    var receivedResult: SplashResult?
    sut.onCompleted = { receivedResult = $0 }

    await sut.startLoading()

    XCTAssertEqual(receivedResult, .needsLogin)
  }

  /*
   로그인 상태에서 readyToMain으로 라우팅되는지 검증하는 테스트

   - Given: 재방문 + 로그인 상태
   - When: startLoading() 호출
   - Then: onCompleted가 .readyToMain으로 호출되는지 확인합니다.
   */
  func test_startLoading_whenSignedIn_callsReadyToMain() async {
    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    mockAuthService.isSignedIn = true

    var receivedResult: SplashResult?
    sut.onCompleted = { receivedResult = $0 }

    await sut.startLoading()

    XCTAssertEqual(receivedResult, .readyToMain)
  }

  /*
   로딩 시작 시 onStepChanged가 .checkingAuth로 호출되는지 검증하는 테스트

   - Given: SplashViewModel
   - When: startLoading() 호출
   - Then: onStepChanged가 .checkingAuth로 호출되는지 확인합니다.
   */
  func test_startLoading_callsOnStepChanged_withCheckingAuth() async {
    var receivedStep: SplashLoadingStep?
    sut.onStepChanged = { receivedStep = $0 }

    await sut.startLoading()

    XCTAssertEqual(receivedStep, .checkingAuth)
  }
}
