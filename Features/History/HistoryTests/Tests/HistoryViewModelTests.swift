//
//  HistoryViewModelTests.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import XCTest
@testable import Core
@testable import HistoryFeature
@testable import HistoryTesting

final class HistoryViewModelTests: XCTestCase {
  private var sut: HistoryViewModel!
  private var mockReadingJourneyService: MockReadingJourneyService!
  
  override func setUp() {
    super.setUp()
    mockReadingJourneyService = MockReadingJourneyService()
    sut = HistoryViewModel(readingJourneyService: mockReadingJourneyService)
  }
  
  override func tearDown() {
    sut = nil
    mockReadingJourneyService = nil
    super.tearDown()
  }
  
  /*
   기록 목록 불러오기 성공 시 journeys가 갱신되고 onJourneysChanged가 호출되는지 검증하는 테스트
   - Given: fetchFinishedJourneys가 기록 목록을 반환하도록 설정된 MockReadingJourneyService
   - When: loadFinishedJourneys() 호출
   - Then: fetchFinishedJourneys 호출 횟수가 1회이고, journeys와 onJourneysChanged 결과가 기대값과 일치하며, onError는 호출되지 않는지 확인합니다.
   */
  func test_loadFinishedJourneys_success_updatesJourneysAndCallsOnJourneysChanged() async {
    let expectedJourneys = [makeFinishedJourney()]
    mockReadingJourneyService.stubbedFetchFinishedJourneysResult = expectedJourneys
    
    var receivedJourneys: [ReadingJourney] = []
    var receivedErrorMessage: String?
    
    sut.onJourneysChanged = { journeys in
      receivedJourneys = journeys
    }
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.loadFinishedJourneys()
    
    XCTAssertEqual(mockReadingJourneyService.fetchFinishedJourneysCallCount, 1)
    XCTAssertEqual(sut.journeys, expectedJourneys)
    XCTAssertEqual(receivedJourneys, expectedJourneys)
    XCTAssertNil(receivedErrorMessage)
  }
  
  /*
   기록 목록 불러오기 성공 시 로딩 상태 콜백이 true/false 순서로 호출되는지 검증하는 테스트
   - Given: fetchFinishedJourneys가 기록 목록을 반환하도록 설정된 MockReadingJourneyService
   - When: loadFinishedJourneys() 호출
   - Then: onLoadingChanged가 true, false 순서로 호출되는지 확인합니다.
   */
  func test_loadFinishedJourneys_success_callsLoadingStateChanged() async {
    mockReadingJourneyService.stubbedFetchFinishedJourneysResult = [makeFinishedJourney()]
    
    var loadingStates: [Bool] = []
    
    sut.onLoadingChanged = { isLoading in
      loadingStates.append(isLoading)
    }
    
    await sut.loadFinishedJourneys()
    
    XCTAssertEqual(loadingStates, [true, false])
  }
  
  /*
   기록 목록 불러오기 실패 시 LocalizedError 메시지를 onError로 전달하는지 검증하는 테스트
   - Given: fetchFinishedJourneys가 LocalizedError를 던지도록 설정된 MockReadingJourneyService
   - When: loadFinishedJourneys() 호출
   - Then: onError가 기대한 에러 메시지로 호출되고, journeys는 비어 있는지 확인합니다.
   */
  func test_loadFinishedJourneys_failure_callsOnErrorWithLocalizedMessage() async {
    mockReadingJourneyService.stubbedFetchFinishedJourneysError = MockLocalizedReadingJourneyError.fetchFinishedFailed
    
    var receivedErrorMessage: String?
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.loadFinishedJourneys()
    
    XCTAssertEqual(mockReadingJourneyService.fetchFinishedJourneysCallCount, 1)
    XCTAssertEqual(sut.journeys, [])
    XCTAssertEqual(receivedErrorMessage, "기록 목록을 불러오지 못했습니다.")
  }
  
  /*
   기록 목록 불러오기 실패 시에도 로딩 상태 콜백이 true/false 순서로 호출되는지 검증하는 테스트
   - Given: fetchFinishedJourneys가 에러를 던지도록 설정된 MockReadingJourneyService
   - When: loadFinishedJourneys() 호출
   - Then: onLoadingChanged가 true, false 순서로 호출되는지 확인합니다.
   */
  func test_loadFinishedJourneys_failure_callsLoadingStateChanged() async {
    mockReadingJourneyService.stubbedFetchFinishedJourneysError = MockReadingJourneyError.failed
    
    var loadingStates: [Bool] = []
    
    sut.onLoadingChanged = { isLoading in
      loadingStates.append(isLoading)
    }
    
    await sut.loadFinishedJourneys()
    
    XCTAssertEqual(loadingStates, [true, false])
  }
  
  /*
   기록 삭제 성공 시 deleteFinishedJourney 호출 후 기록 목록을 다시 불러오는지 검증하는 테스트
   - Given: deleteFinishedJourney는 성공하고 fetchFinishedJourneys가 빈 배열을 반환하도록 설정된 MockReadingJourneyService
   - When: deleteFinishedJourney(journeyId:) 호출
   - Then: deleteFinishedJourney와 fetchFinishedJourneys가 각각 1회 호출되고, journeys가 빈 배열로 갱신되는지 확인합니다.
   */
  func test_deleteFinishedJourney_success_deletesJourneyAndReloadsFinishedJourneys() async {
    let journeyId = "journey-id"
    mockReadingJourneyService.stubbedFetchFinishedJourneysResult = []
    
    var receivedJourneys: [ReadingJourney] = [makeFinishedJourney()]
    
    sut.onJourneysChanged = { journeys in
      receivedJourneys = journeys
    }
    
    await sut.deleteFinishedJourney(journeyId: journeyId)
    
    XCTAssertEqual(mockReadingJourneyService.deleteFinishedJourneyCallCount, 1)
    XCTAssertEqual(mockReadingJourneyService.lastDeletedFinishedJourneyId, journeyId)
    XCTAssertEqual(mockReadingJourneyService.fetchFinishedJourneysCallCount, 1)
    XCTAssertEqual(receivedJourneys, [])
  }
  
  /*
   기록 삭제 실패 시 onError가 호출되고 기록 목록을 다시 불러오지 않는지 검증하는 테스트
   - Given: deleteFinishedJourney가 LocalizedError를 던지도록 설정된 MockReadingJourneyService
   - When: deleteFinishedJourney(journeyId:) 호출
   - Then: onError가 호출되고 fetchFinishedJourneys는 호출되지 않는지 확인합니다.
   */
  func test_deleteFinishedJourney_failure_callsOnErrorAndDoesNotReloadFinishedJourneys() async {
    let journeyId = "journey-id"
    mockReadingJourneyService.stubbedDeleteFinishedJourneyError = MockLocalizedReadingJourneyError.deleteFinishedFailed
    
    var receivedErrorMessage: String?
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.deleteFinishedJourney(journeyId: journeyId)
    
    XCTAssertEqual(mockReadingJourneyService.deleteFinishedJourneyCallCount, 1)
    XCTAssertEqual(mockReadingJourneyService.lastDeletedFinishedJourneyId, journeyId)
    XCTAssertEqual(mockReadingJourneyService.fetchFinishedJourneysCallCount, 0)
    XCTAssertEqual(receivedErrorMessage, "기록 삭제에 실패했습니다.")
  }
}

// MARK: - Helper
private extension HistoryViewModelTests {
  func makeFinishedJourney() -> ReadingJourney {
    ReadingJourney(
      id: "journey-id",
      status: .finished,
      departureAirport: makeDepartureAirport(),
      arrivalAirport: makeArrivalAirport(),
      distanceKm: 540,
      remainingDistanceKm: 0,
      book: makeBookInfo(),
      reason: nil,
      startedAt: Date(timeIntervalSince1970: 1_700_000_000),
      finishedAt: Date(timeIntervalSince1970: 1_700_000_500),
      currentPage: 320,
      progressUpdatedAt: Date(timeIntervalSince1970: 1_700_000_500),
      review: "정말 좋았던 책입니다.",
      createdAt: Date(timeIntervalSince1970: 1_700_000_000),
      updatedAt: Date(timeIntervalSince1970: 1_700_000_500),
      lastUpdatedAt: Date(timeIntervalSince1970: 1_700_000_500)
    )
  }
  
  func makeBookInfo() -> BookInfo {
    BookInfo(
      isbn13: "9788937460616",
      title: "테스트 도서",
      author: "테스트 작가",
      publisher: "테스트 출판사",
      itemPage: 320,
      cover: "https://example.com/cover.jpg",
      description: "test"
    )
  }
  
  func makeDepartureAirport() -> AirportInfo {
    AirportInfo(
      iata: "ICN",
      airportNameEn: "Incheon International Airport",
      airportNameKo: "인천국제공항",
      cityNameEn: "Seoul",
      cityNameKo: "서울",
      countryNameKo: "대한민국",
      latitude: 37.4602,
      longitude: 126.4407,
      searchText: "icn incheon seoul 인천 서울"
    )
  }
  
  func makeArrivalAirport() -> AirportInfo {
    AirportInfo(
      iata: "NRT",
      airportNameEn: "Narita International Airport",
      airportNameKo: "나리타국제공항",
      cityNameEn: "Tokyo",
      cityNameKo: "도쿄",
      countryNameKo: "일본",
      latitude: 35.7719,
      longitude: 140.3929,
      searchText: "nrt narita tokyo 나리타 도쿄"
    )
  }
}
