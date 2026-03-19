//
//  HomeViewModelTests.swift
//  Home
//
//  Created by 여성일 on 3/11/26.
//

import XCTest
@testable import Core
@testable import HomeFeature
@testable import HomeTesting

final class HomeViewModelTests: XCTestCase {
  private var sut: HomeViewModel!
  private var mockReadingJourneyService: MockReadingJourneyService!

  override func setUp() {
    super.setUp()
    mockReadingJourneyService = MockReadingJourneyService()
    sut = HomeViewModel(readingJourneyService: mockReadingJourneyService)
  }

  override func tearDown() {
    sut = nil
    mockReadingJourneyService = nil
    super.tearDown()
  }

  /*
   독서 진행률이 정상적으로 계산되는지 검증하는 테스트

   - Given: currentPage와 전체 페이지 수(itemPage)가 있는 ReadingJourney
   - When: calculateProgress(journey:) 호출
   - Then: currentPage / itemPage 값으로 진행률이 정상 계산되는지 확인합니다.
   */
  func test_calculateProgress_normal() {
    let journey = makeReadingJourney(
      currentPage: 200,
      itemPage: 584
    )

    let progress = sut.calculateProgress(journey: journey)

    XCTAssertEqual(progress, 200.0 / 584.0, accuracy: 0.001)
  }

  /*
   currentPage가 없는 경우 진행률이 0으로 계산되는지 검증하는 테스트

   - Given: currentPage가 nil인 ReadingJourney
   - When: calculateProgress(journey:) 호출
   - Then: 진행률이 0을 반환하는지 확인합니다.
   */
  func test_calculateProgress_whenCurrentPageIsNil_returnsZero() {
    let journey = makeReadingJourney(
      currentPage: nil,
      itemPage: 584
    )

    let progress = sut.calculateProgress(journey: journey)

    XCTAssertEqual(progress, 0)
  }

  /*
   전체 페이지 수가 0인 경우 진행률이 0으로 계산되는지 검증하는 테스트

   - Given: itemPage가 0인 ReadingJourney
   - When: calculateProgress(journey:) 호출
   - Then: 진행률이 0을 반환하는지 확인합니다.
   */
  func test_calculateProgress_whenItemPageIsZero_returnsZero() {
    let journey = makeReadingJourney(
      currentPage: 100,
      itemPage: 0
    )

    let progress = sut.calculateProgress(journey: journey)

    XCTAssertEqual(progress, 0)
  }

  /*
   현재 페이지가 전체 페이지 수를 초과하는 경우 진행률이 1로 보정되는지 검증하는 테스트

   - Given: currentPage가 itemPage보다 큰 ReadingJourney
   - When: calculateProgress(journey:) 호출
   - Then: 진행률이 1을 반환하는지 확인합니다.
   */
  func test_calculateProgress_whenCurrentPageExceedsItemPage_returnsOne() {
    let journey = makeReadingJourney(
      currentPage: 1000,
      itemPage: 300
    )

    let progress = sut.calculateProgress(journey: journey)

    XCTAssertEqual(progress, 1)
  }

  /*
   여행 개수가 journeys.count와 동일한지 검증하는 테스트

   - Given: 여러 개의 ReadingJourney를 반환하는 MockReadingJourneyService
   - When: loadReadingJourneys 호출
   - Then: tripCount가 불러온 여행 개수와 동일한지 확인합니다.
   */
  func test_tripCount_matchesJourneysCount() async {
    mockReadingJourneyService.stubbedFetchReadingJourneysResult = [
      makeReadingJourney(id: "journey-1"),
      makeReadingJourney(id: "journey-2")
    ]

    await sut.loadReadingJourneys()

    XCTAssertEqual(sut.tripCount, 2)
  }

  /*
   모든 여행의 총 이동 거리가 정상적으로 합산되는지 검증하는 테스트

   - Given: distanceKm가 서로 다른 여러 ReadingJourney
   - When: loadReadingJourneys 호출 후 totalDistance 조회
   - Then: 각 여행의 distanceKm 값이 모두 합산된 결과가 반환되는지 확인합니다.
   */
  func test_totalDistance_sumsDistance() async {
    mockReadingJourneyService.stubbedFetchReadingJourneysResult = [
      makeReadingJourney(id: "journey-1", distanceKm: 540),
      makeReadingJourney(id: "journey-2", distanceKm: 820)
    ]

    await sut.loadReadingJourneys()

    XCTAssertEqual(sut.totalDistance, 540 + 820)
  }

  /*
   journeys가 비어있는 경우 총 이동 거리가 0인지 검증하는 테스트

   - Given: 빈 여행 목록을 반환하는 MockReadingJourneyService
   - When: loadReadingJourneys 호출 후 totalDistance 조회
   - Then: totalDistance가 0인지 확인합니다.
   */
  func test_totalDistance_whenJourneysEmpty_returnsZero() async {
    mockReadingJourneyService.stubbedFetchReadingJourneysResult = []

    await sut.loadReadingJourneys()

    XCTAssertEqual(sut.totalDistance, 0)
  }

  /*
   가장 최근에 업데이트된 여행이 latestJourney로 반환되는지 검증하는 테스트

   - Given: lastUpdatedAt이 서로 다른 여러 ReadingJourney
   - When: loadReadingJourneys 호출 후 latestJourney 조회
   - Then: 가장 최신 lastUpdatedAt을 가진 여행이 반환되는지 확인합니다.
   */
  func test_latestJourney_returnsMostRecentlyUpdatedJourney() async {
    let oldJourney = makeReadingJourney(
      id: "journey-old",
      lastUpdatedAt: Date(timeIntervalSince1970: 1_700_000_000)
    )

    let latestJourney = makeReadingJourney(
      id: "journey-latest",
      lastUpdatedAt: Date(timeIntervalSince1970: 1_800_000_000)
    )

    mockReadingJourneyService.stubbedFetchReadingJourneysResult = [
      oldJourney,
      latestJourney
    ]

    await sut.loadReadingJourneys()

    XCTAssertEqual(sut.latestJourney?.id, "journey-latest")
  }

  /*
   여행 목록을 성공적으로 불러오면 journeys가 업데이트되고 onJourneysChanged가 호출되는지 검증하는 테스트

   - Given: ReadingJourney 목록을 반환하는 MockReadingJourneyService
   - When: loadReadingJourneys 호출
   - Then: journeys가 업데이트되고 onJourneysChanged가 호출되는지 확인합니다.
   */
  func test_loadReadingJourneys_success_updatesJourneys_andCallsOnJourneysChanged() async {
    let expectedJourneys = [
      makeReadingJourney(id: "journey-1"),
      makeReadingJourney(id: "journey-2")
    ]

    mockReadingJourneyService.stubbedFetchReadingJourneysResult = expectedJourneys

    let expectation = expectation(description: "onJourneysChanged called")

    var receivedJourneys: [ReadingJourney] = []

    sut.onJourneysChanged = { journeys in
      receivedJourneys = journeys
      expectation.fulfill()
    }

    await sut.loadReadingJourneys()

    await fulfillment(of: [expectation], timeout: 1.0)
    XCTAssertEqual(sut.journeys, expectedJourneys)
    XCTAssertEqual(receivedJourneys, expectedJourneys)
  }

  /*
   여행 목록 불러오기에 실패하면 onError가 호출되는지 검증하는 테스트

   - Given: 에러를 던지도록 설정된 MockReadingJourneyService
   - When: loadReadingJourneys 호출
   - Then: onError가 호출되고 에러 메시지가 전달되는지 확인합니다.
   */
  func test_loadReadingJourneys_failure_callsOnError() async {
    mockReadingJourneyService.stubbedFetchReadingJourneysError = MockLocalizedReadingJourneyError.fetchFailed

    let expectation = expectation(description: "onError called")

    var receivedMessage: String?

    sut.onError = { message in
      receivedMessage = message
      expectation.fulfill()
    }

    await sut.loadReadingJourneys()

    await fulfillment(of: [expectation], timeout: 1.0)
    XCTAssertEqual(receivedMessage, "독서 여행을 불러오지 못했습니다.")
  }

  /*
   greetingText가 비어 있지 않은지 검증하는 테스트

   - Given: HomeViewModel
   - When: greetingText 조회
   - Then: 시간대에 맞는 인사말 문자열이 비어 있지 않은지 확인합니다.
   */
  func test_greetingText_isNotEmpty() {
    XCTAssertFalse(sut.greetingText.isEmpty)
  }
}

// MARK: - Helper
private extension HomeViewModelTests {
  func makeReadingJourney(
    id: String = "journey-id",
    distanceKm: Double = 540,
    currentPage: Int? = 200,
    itemPage: Int = 584,
    lastUpdatedAt: Date = Date()
  ) -> ReadingJourney {
    ReadingJourney(
      id: id,
      status: .reading,
      departureAirport: makeDepartureAirport(),
      arrivalAirport: makeArrivalAirport(),
      distanceKm: distanceKm,
      remainingDistanceKm: 300,
      book: makeBookInfo(itemPage: itemPage),
      reason: nil,
      startedAt: Date(timeIntervalSince1970: 1_700_000_000),
      finishedAt: nil,
      currentPage: currentPage,
      progressUpdatedAt: Date(timeIntervalSince1970: 1_700_000_100),
      review: nil,
      createdAt: Date(timeIntervalSince1970: 1_700_000_000),
      updatedAt: nil,
      lastUpdatedAt: lastUpdatedAt
    )
  }

  func makeBookInfo(itemPage: Int = 584) -> BookInfo {
    BookInfo(
      isbn13: "9788937460616",
      title: "테스트 도서",
      author: "테스트 작가",
      publisher: "테스트 출판사",
      itemPage: itemPage,
      cover: "https://example.com/cover.jpg"
    )
  }
  
  func makeDepartureAirport() -> AirportInfo {
    AirportInfo(
      iata: "CJJ",
      airportNameEn: "Cheongju International Airport",
      airportNameKo: "청주국제공항",
      cityNameEn: "Cheongju",
      cityNameKo: "청주",
      countryNameKo: "대한민국",
      latitude: 36.7170,
      longitude: 127.4991,
      searchText: "cjj cheongju 청주 청주국제공항"
    )
  }

  func makeArrivalAirport() -> AirportInfo {
    AirportInfo(
      iata: "FUK",
      airportNameEn: "Fukuoka Airport",
      airportNameKo: "후쿠오카 공항",
      cityNameEn: "Fukuoka",
      cityNameKo: "후쿠오카",
      countryNameKo: "일본",
      latitude: 33.5859,
      longitude: 130.4510,
      searchText: "fuk fukuoka 후쿠오카 후쿠오카공항"
    )
  }
}
