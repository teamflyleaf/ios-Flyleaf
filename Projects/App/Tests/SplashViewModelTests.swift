//
//  SplashViewModelTests.swift
//  App
//
//  Created by 여성일 on 5/31/26.
//

import XCTest
import Core
import ReadingJourneyInterface
@testable import FlyleafDev

final class SplashViewModelTests: XCTestCase {
  private var sut: SplashViewModel!
  private var mockAuthService: MockAuthService!
  private var mockReadingJourneyService: MockReadingJourneyService!

  override func setUp() {
    super.setUp()
    UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
    mockAuthService = MockAuthService()
    mockReadingJourneyService = MockReadingJourneyService()
    sut = SplashViewModel(
      authService: mockAuthService,
      readingJourneyService: mockReadingJourneyService,
      minimumDisplayDuration: .seconds(0)
    )
  }

  override func tearDown() {
    UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
    sut = nil
    mockAuthService = nil
    mockReadingJourneyService = nil
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
   재방문 + 로그아웃 상태에서 needsLogin으로 라우팅되는지 검증하는 테스트

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
   재방문 + 로그인 상태에서 패치 성공 시 readyToMain(journeys)으로 라우팅되는지 검증하는 테스트

   - Given: 재방문 + 로그인 상태, 패치 성공
   - When: startLoading() 호출
   - Then: onCompleted가 .readyToMain(journeys)으로 호출되는지 확인합니다.
   */
  func test_startLoading_whenSignedIn_andFetchSuccess_callsReadyToMainWithJourneys() async {
    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    mockAuthService.isSignedIn = true
    mockReadingJourneyService.stubbedFetchReadingJourneysResult = [
      makeReadingJourney(id: "journey-1")
    ]

    var receivedResult: SplashResult?
    sut.onCompleted = { receivedResult = $0 }

    await sut.startLoading()

    XCTAssertEqual(receivedResult, .readyToMain([makeReadingJourney(id: "journey-1")]))
  }

  /*
   재방문 + 로그인 상태에서 패치 실패 시 onError와 readyToMain([])이 호출되는지 검증하는 테스트

   - Given: 재방문 + 로그인 상태, 패치 실패
   - When: startLoading() 호출
   - Then: onError가 호출되고 onCompleted가 .readyToMain([])으로 호출되는지 확인합니다.
   */
  func test_startLoading_whenSignedIn_andFetchFails_callsOnError_andReadyToMainWithEmpty() async {
    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    mockAuthService.isSignedIn = true
    mockReadingJourneyService.stubbedFetchReadingJourneysError = MockReadingJourneyError.fetchFailed

    var receivedResult: SplashResult?
    var receivedError: String?
    sut.onCompleted = { receivedResult = $0 }
    sut.onError = { receivedError = $0 }

    await sut.startLoading()

    XCTAssertEqual(receivedError, "여행 데이터를 불러오지 못했습니다.")
    XCTAssertEqual(receivedResult, .readyToMain([]))
  }

  /*
   로딩 시작 시 checkingAuth 스텝으로 변경되는지 검증하는 테스트

   - Given: SplashViewModel
   - When: startLoading() 호출
   - Then: onStepChanged가 .checkingAuth로 먼저 호출되는지 확인합니다.
   */
  func test_startLoading_callsOnStepChanged_withCheckingAuth() async {
    var receivedSteps: [SplashLoadingStep] = []
    sut.onStepChanged = { receivedSteps.append($0) }

    await sut.startLoading()

    XCTAssertTrue(receivedSteps.contains(.checkingAuth))
  }

  /*
   로그인 상태일 때 checkingAuth → fetchingData 순서로 스텝이 변경되는지 검증하는 테스트

   - Given: 재방문 + 로그인 상태
   - When: startLoading() 호출
   - Then: onStepChanged가 .checkingAuth → .fetchingData 순서로 호출되는지 확인합니다.
   */
  func test_startLoading_whenSignedIn_callsSteps_checkingAuth_then_fetchingData() async {
    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    mockAuthService.isSignedIn = true

    var receivedSteps: [SplashLoadingStep] = []
    sut.onStepChanged = { receivedSteps.append($0) }

    await sut.startLoading()

    XCTAssertEqual(receivedSteps, [.checkingAuth, .fetchingData])
  }
}

// MARK: - Helper
private extension SplashViewModelTests {
  func makeReadingJourney(id: String = "journey-id") -> ReadingJourney {
    ReadingJourney(
      id: id,
      status: .reading,
      departureAirport: makeAirportInfo(iata: "CJJ"),
      arrivalAirport: makeAirportInfo(iata: "FUK"),
      distanceKm: 540,
      remainingDistanceKm: 300,
      book: makeBookInfo(),
      reason: nil,
      startedAt: Date(timeIntervalSince1970: 1_700_000_000),
      finishedAt: nil,
      currentPage: 200,
      progressUpdatedAt: nil,
      review: nil,
      createdAt: Date(timeIntervalSince1970: 1_700_000_000),
      updatedAt: nil,
      lastUpdatedAt: Date(timeIntervalSince1970: 1_700_000_000)
    )
  }

  func makeAirportInfo(iata: String) -> AirportInfo {
    AirportInfo(
      iata: iata,
      airportNameEn: "Test Airport",
      airportNameKo: "테스트 공항",
      cityNameEn: "Test City",
      cityNameKo: "테스트 도시",
      countryNameKo: "테스트 국가",
      latitude: 0,
      longitude: 0,
      searchText: iata
    )
  }

  func makeBookInfo() -> BookInfo {
    BookInfo(
      isbn13: "9788937460616",
      title: "테스트 도서",
      author: "테스트 작가",
      publisher: "테스트 출판사",
      itemPage: 584,
      cover: "https://example.com/cover.jpg",
      description: "테스트"
    )
  }
}
