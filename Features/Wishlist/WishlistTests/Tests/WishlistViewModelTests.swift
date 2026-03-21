//
//  WishlistViewModelTests.swift
//  Wishlist
//
//  Created by 여성일 on 3/21/26.
//

import XCTest
@testable import Core
@testable import WishlistFeature
@testable import WishlistTesting

final class WishlistViewModelTests: XCTestCase {
  private var sut: WishlistViewModel!
  private var mockReadingJourneyService: MockReadingJourneyService!
  
  override func setUp() {
    super.setUp()
    mockReadingJourneyService = MockReadingJourneyService()
    sut = WishlistViewModel(
      readingJourneyService: mockReadingJourneyService
    )
  }
  
  override func tearDown() {
    sut = nil
    mockReadingJourneyService = nil
    super.tearDown()
  }
  
  /*
   예약 목록 개수가 journeys.count와 동일한지 검증하는 테스트
   - Given: 여러 개의 wishlist journey가 저장된 상태
   - When: numberOfItems 조회
   - Then: journeys.count와 동일한 값을 반환하는지 확인합니다.
   */
  func test_numberOfItems_returnsJourneysCount() async {
    mockReadingJourneyService.stubbedFetchWishlistResult = [
      makeWishlistJourney(id: "journey-1"),
      makeWishlistJourney(id: "journey-2")
    ]
    
    await sut.loadWishlistJourneys()
    
    XCTAssertEqual(sut.numberOfItems, 2)
  }
  
  /*
   예약 목록을 성공적으로 불러오면 journeys가 업데이트되고 onJourneysChanged가 호출되는지 검증하는 테스트
   - Given: wishlist journey 목록을 반환하는 MockReadingJourneyService
   - When: loadWishlistJourneys 호출
   - Then:
     - fetchWishlist가 1번 호출되는지
     - journeys가 업데이트되는지
     - onJourneysChanged가 호출되는지 확인합니다.
   */
  func test_loadWishlistJourneys_success_updatesJourneys_andCallsOnJourneysChanged() async {
    let expectedJourneys = [
      makeWishlistJourney(id: "journey-1"),
      makeWishlistJourney(id: "journey-2")
    ]
    mockReadingJourneyService.stubbedFetchWishlistResult = expectedJourneys
    
    let expectation = expectation(description: "onJourneysChanged called")
    var receivedJourneys: [ReadingJourney] = []
    
    sut.onJourneysChanged = { journeys in
      receivedJourneys = journeys
      expectation.fulfill()
    }
    
    await sut.loadWishlistJourneys()
    
    await fulfillment(of: [expectation], timeout: 1.0)
    
    XCTAssertEqual(mockReadingJourneyService.fetchWishlistCallCount, 1)
    XCTAssertEqual(sut.journeys, expectedJourneys)
    XCTAssertEqual(receivedJourneys, expectedJourneys)
  }
  
  /*
   예약 목록 불러오기에 실패하면 onError가 호출되는지 검증하는 테스트
   - Given: 에러를 던지도록 설정된 MockReadingJourneyService
   - When: loadWishlistJourneys 호출
   - Then:
     - fetchWishlist가 1번 호출되는지
     - onError가 호출되고 에러 메시지가 전달되는지 확인합니다.
   */
  func test_loadWishlistJourneys_failure_callsOnError() async {
    mockReadingJourneyService.stubbedFetchWishlistError = MockLocalizedReadingJourneyError.custom
    
    let expectation = expectation(description: "onError called")
    var receivedMessage: String?
    
    sut.onError = { message in
      receivedMessage = message
      expectation.fulfill()
    }
    
    await sut.loadWishlistJourneys()
    
    await fulfillment(of: [expectation], timeout: 1.0)
    
    XCTAssertEqual(mockReadingJourneyService.fetchWishlistCallCount, 1)
    XCTAssertEqual(receivedMessage, "중복된 독서 여행입니다.")
  }
  
  /*
   예약 삭제가 성공하면 deleteWishlistJourney 호출 후 목록을 다시 불러오는지 검증하는 테스트
   - Given:
     - 삭제 대상 journeyId
     - 삭제 후 새 wishlist 목록을 반환하는 MockReadingJourneyService
   - When: deleteWishlistJourney 호출
   - Then:
     - deleteWishlistJourney가 1번 호출되는지
     - 전달된 journeyId가 올바른지
     - fetchWishlist가 다시 호출되는지
     - journeys가 최신 목록으로 갱신되는지 확인합니다.
   */
  func test_deleteWishlistJourney_success_deletesAndReloadsJourneys() async {
    let reloadedJourneys = [
      makeWishlistJourney(id: "journey-2")
    ]
    mockReadingJourneyService.stubbedFetchWishlistResult = reloadedJourneys
    
    let expectation = expectation(description: "onJourneysChanged called after delete")
    var receivedJourneys: [ReadingJourney] = []
    
    sut.onJourneysChanged = { journeys in
      receivedJourneys = journeys
      expectation.fulfill()
    }
    
    await sut.deleteWishlistJourney(journeyId: "journey-1")
    
    await fulfillment(of: [expectation], timeout: 1.0)
    
    XCTAssertEqual(mockReadingJourneyService.deleteWishlistJourneyCallCount, 1)
    XCTAssertEqual(mockReadingJourneyService.receivedJourneyId, "journey-1")
    XCTAssertEqual(mockReadingJourneyService.fetchWishlistCallCount, 1)
    XCTAssertEqual(sut.journeys, reloadedJourneys)
    XCTAssertEqual(receivedJourneys, reloadedJourneys)
  }
  
  /*
   예약 삭제에 실패하면 onError가 호출되고 목록 재조회는 하지 않는지 검증하는 테스트
   - Given: 삭제 시 에러를 던지도록 설정된 MockReadingJourneyService
   - When: deleteWishlistJourney 호출
   - Then:
     - deleteWishlistJourney가 1번 호출되는지
     - fetchWishlist는 호출되지 않는지
     - onError가 호출되고 에러 메시지가 전달되는지 확인합니다.
   */
  func test_deleteWishlistJourney_failure_callsOnError_andDoesNotReload() async {
    mockReadingJourneyService.stubbedDeleteWishlistJourneyError = MockLocalizedReadingJourneyError.custom
    
    let expectation = expectation(description: "onError called")
    var receivedMessage: String?
    
    sut.onError = { message in
      receivedMessage = message
      expectation.fulfill()
    }
    
    await sut.deleteWishlistJourney(journeyId: "journey-1")
    
    await fulfillment(of: [expectation], timeout: 1.0)
    
    XCTAssertEqual(mockReadingJourneyService.deleteWishlistJourneyCallCount, 1)
    XCTAssertEqual(mockReadingJourneyService.receivedJourneyId, "journey-1")
    XCTAssertEqual(mockReadingJourneyService.fetchWishlistCallCount, 0)
    XCTAssertEqual(receivedMessage, "중복된 독서 여행입니다.")
  }
}

// MARK: - Helper
private extension WishlistViewModelTests {
  func makeWishlistJourney(
    id: String = "journey-id"
  ) -> ReadingJourney {
    ReadingJourney(
      id: id,
      status: .wishlist,
      departureAirport: makeDepartureAirport(),
      arrivalAirport: makeArrivalAirport(),
      distanceKm: 540,
      remainingDistanceKm: 540,
      book: makeBookInfo(),
      reason: "읽고 싶어서",
      startedAt: nil,
      finishedAt: nil,
      currentPage: nil,
      progressUpdatedAt: nil,
      review: nil,
      createdAt: Date(timeIntervalSince1970: 1_700_000_000),
      updatedAt: nil,
      lastUpdatedAt: Date(timeIntervalSince1970: 1_700_000_000)
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
      iata: "PUS",
      airportNameEn: "Gimhae International Airport",
      airportNameKo: "김해국제공항",
      cityNameEn: "Busan",
      cityNameKo: "부산",
      countryNameKo: "대한민국",
      latitude: 35.1796,
      longitude: 128.9382,
      searchText: "pus busan 부산 김해국제공항"
    )
  }
}
