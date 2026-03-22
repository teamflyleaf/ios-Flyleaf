//
//  JourneyViewModelTests.swift
//  Journey
//
//  Created by 여성일 on 3/22/26.
//

import XCTest
@testable import Core
@testable import JourneyFeature
@testable import JourneyTesting

final class JourneyViewModelTests: XCTestCase {
  private var sut: JourneyViewModel!
  private var mockReadingJourneyService: MockReadingJourneyService!
  private var mockJourneyMemoService: MockJourneyMemoService!
  
  override func setUp() {
    super.setUp()
    mockReadingJourneyService = MockReadingJourneyService()
    mockJourneyMemoService = MockJourneyMemoService()
    
    sut = JourneyViewModel(
      readingJourneyService: mockReadingJourneyService,
      memoService: mockJourneyMemoService
    )
  }
  
  override func tearDown() {
    sut = nil
    mockReadingJourneyService = nil
    mockJourneyMemoService = nil
    super.tearDown()
  }
  
  /*
   여행 목록 불러오기 성공 시 journeys가 갱신되고 onJourneysChanged가 호출되는지 검증하는 테스트
   - Given: fetchReadingJourneys가 여행 목록을 반환하도록 설정된 MockReadingJourneyService
   - When: loadReadingJourneys() 호출
   - Then: fetchReadingJourneys 호출 횟수가 1회이고, journeys와 onJourneysChanged 결과가 기대값과 일치하며, onError는 호출되지 않는지 확인합니다.
   */
  func test_loadReadingJourneys_success_updatesJourneysAndCallsOnJourneysChanged() async {
    let expectedJourneys = [makeReadingJourney()]
    mockReadingJourneyService.stubbedFetchReadingJourneysResult = expectedJourneys
    
    var receivedJourneys: [ReadingJourney] = []
    var receivedErrorMessage: String?
    
    sut.onJourneysChanged = { journeys in
      receivedJourneys = journeys
    }
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.loadReadingJourneys()
    
    XCTAssertEqual(mockReadingJourneyService.fetchReadingJourneysCallCount, 1)
    XCTAssertEqual(sut.journeys, expectedJourneys)
    XCTAssertEqual(receivedJourneys, expectedJourneys)
    XCTAssertNil(receivedErrorMessage)
  }
  
  /*
   여행 목록 불러오기 실패 시 LocalizedError 메시지를 onError로 전달하는지 검증하는 테스트
   - Given: fetchReadingJourneys가 LocalizedError를 던지도록 설정된 MockReadingJourneyService
   - When: loadReadingJourneys() 호출
   - Then: onError가 기대한 에러 메시지로 호출되고, journeys는 비어 있는지 확인합니다.
   */
  func test_loadReadingJourneys_failure_callsOnErrorWithLocalizedMessage() async {
    mockReadingJourneyService.stubbedFetchReadingJourneysError = MockLocalizedReadingJourneyError.fetchFailed
    
    var receivedErrorMessage: String?
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.loadReadingJourneys()
    
    XCTAssertEqual(mockReadingJourneyService.fetchReadingJourneysCallCount, 1)
    XCTAssertEqual(sut.journeys, [])
    XCTAssertEqual(receivedErrorMessage, "독서 여행을 불러오지 못했습니다.")
  }
  
  /*
   여행 목록 불러오기 실패 시 일반 Error에 대해 기본 메시지를 onError로 전달하는지 검증하는 테스트
   - Given: fetchReadingJourneys가 일반 Error를 던지도록 설정된 MockReadingJourneyService
   - When: loadReadingJourneys() 호출
   - Then: onError가 기본 에러 메시지로 호출되는지 확인합니다.
   */
  func test_loadReadingJourneys_nonLocalizedError_callsDefaultErrorMessage() async {
    mockReadingJourneyService.stubbedFetchReadingJourneysError = MockReadingJourneyError.failed
    
    var receivedErrorMessage: String?
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.loadReadingJourneys()
    
    XCTAssertEqual(receivedErrorMessage, "여행 목록을 불러오지 못했습니다.")
  }
  
  /*
   메모 목록 불러오기 성공 시 memos가 갱신되고 onMemosChanged가 호출되는지 검증하는 테스트
   - Given: fetchMemos가 메모 목록을 반환하도록 설정된 MockJourneyMemoService
   - When: loadMemos(journeyId:) 호출
   - Then: fetchMemos 호출 횟수와 journeyId가 올바르며, memos와 onMemosChanged 결과가 기대값과 일치하는지 확인합니다.
   */
  func test_loadMemos_success_updatesMemosAndCallsOnMemosChanged() async {
    let journeyId = "journey-id"
    let expectedMemos = [makeJourneyMemo()]
    mockJourneyMemoService.stubbedFetchMemosResult = expectedMemos
    
    var receivedMemos: [JourneyMemo] = []
    var receivedErrorMessage: String?
    
    sut.onMemosChanged = { memos in
      receivedMemos = memos
    }
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.loadMemos(journeyId: journeyId)
    
    XCTAssertEqual(mockJourneyMemoService.fetchMemosCallCount, 1)
    XCTAssertEqual(mockJourneyMemoService.lastFetchJourneyId, journeyId)
    XCTAssertEqual(sut.memos, expectedMemos)
    XCTAssertEqual(receivedMemos, expectedMemos)
    XCTAssertNil(receivedErrorMessage)
  }
  
  /*
   메모 목록 불러오기 실패 시 onError가 호출되는지 검증하는 테스트
   - Given: fetchMemos가 LocalizedError를 던지도록 설정된 MockJourneyMemoService
   - When: loadMemos(journeyId:) 호출
   - Then: onError가 기대한 에러 메시지로 호출되는지 확인합니다.
   */
  func test_loadMemos_failure_callsOnError() async {
    let journeyId = "journey-id"
    mockJourneyMemoService.stubbedFetchMemosError = MockLocalizedJourneyMemoError.fetchFailed
    
    var receivedErrorMessage: String?
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.loadMemos(journeyId: journeyId)
    
    XCTAssertEqual(mockJourneyMemoService.fetchMemosCallCount, 1)
    XCTAssertEqual(receivedErrorMessage, "메모를 불러오지 못했습니다.")
  }
  
  /*
   메모 저장 성공 시 createMemo 호출 후 메모 목록을 다시 불러와 onMemosChanged가 호출되는지 검증하는 테스트
   - Given: createMemo는 성공하고 fetchMemos가 최신 메모 목록을 반환하도록 설정된 MockJourneyMemoService
   - When: saveMemo(journeyId:memo:) 호출
   - Then: createMemo와 fetchMemos가 각각 1회 호출되고, onMemosChanged가 최신 목록으로 호출되는지 확인합니다.
   */
  func test_saveMemo_success_createsMemoAndReloadsMemos() async {
    let journeyId = "journey-id"
    let newMemo = makeJourneyMemo()
    let expectedMemos = [newMemo]
    mockJourneyMemoService.stubbedFetchMemosResult = expectedMemos
    
    var receivedMemos: [JourneyMemo] = []
    var receivedErrorMessage: String?
    
    sut.onMemosChanged = { memos in
      receivedMemos = memos
    }
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.saveMemo(journeyId: journeyId, memo: newMemo)
    
    XCTAssertEqual(mockJourneyMemoService.createMemoCallCount, 1)
    XCTAssertEqual(mockJourneyMemoService.lastCreateJourneyId, journeyId)
    XCTAssertEqual(mockJourneyMemoService.lastCreatedMemo, newMemo)
    XCTAssertEqual(mockJourneyMemoService.fetchMemosCallCount, 1)
    XCTAssertEqual(receivedMemos, expectedMemos)
    XCTAssertNil(receivedErrorMessage)
  }
  
  /*
   메모 저장 실패 시 onError가 호출되고 메모 목록을 다시 불러오지 않는지 검증하는 테스트
   - Given: createMemo가 LocalizedError를 던지도록 설정된 MockJourneyMemoService
   - When: saveMemo(journeyId:memo:) 호출
   - Then: onError가 호출되고 fetchMemos는 호출되지 않는지 확인합니다.
   */
  func test_saveMemo_failure_callsOnErrorAndDoesNotReloadMemos() async {
    let journeyId = "journey-id"
    let memo = makeJourneyMemo()
    mockJourneyMemoService.stubbedCreateMemoError = MockLocalizedJourneyMemoError.saveFailed
    
    var receivedErrorMessage: String?
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.saveMemo(journeyId: journeyId, memo: memo)
    
    XCTAssertEqual(mockJourneyMemoService.createMemoCallCount, 1)
    XCTAssertEqual(mockJourneyMemoService.fetchMemosCallCount, 0)
    XCTAssertEqual(receivedErrorMessage, "메모 저장에 실패했습니다.")
  }
  
  /*
   메모 수정 성공 시 updateMemo 호출 후 메모 목록을 다시 불러오는지 검증하는 테스트
   - Given: updateMemo는 성공하고 fetchMemos가 최신 메모 목록을 반환하도록 설정된 MockJourneyMemoService
   - When: updateMemo(journeyId:memo:) 호출
   - Then: updateMemo와 fetchMemos가 각각 1회 호출되고, onMemosChanged가 최신 목록으로 호출되는지 확인합니다.
   */
  func test_updateMemo_success_updatesMemoAndReloadsMemos() async {
    let journeyId = "journey-id"
    let updatedMemo = makeJourneyMemo()
    let expectedMemos = [updatedMemo]
    mockJourneyMemoService.stubbedFetchMemosResult = expectedMemos
    
    var receivedMemos: [JourneyMemo] = []
    
    sut.onMemosChanged = { memos in
      receivedMemos = memos
    }
    
    await sut.updateMemo(journeyId: journeyId, memo: updatedMemo)
    
    XCTAssertEqual(mockJourneyMemoService.updateMemoCallCount, 1)
    XCTAssertEqual(mockJourneyMemoService.lastUpdateJourneyId, journeyId)
    XCTAssertEqual(mockJourneyMemoService.lastUpdatedMemo, updatedMemo)
    XCTAssertEqual(mockJourneyMemoService.fetchMemosCallCount, 1)
    XCTAssertEqual(receivedMemos, expectedMemos)
  }
  
  /*
   메모 수정 실패 시 onError가 호출되고 메모 목록을 다시 불러오지 않는지 검증하는 테스트
   - Given: updateMemo가 LocalizedError를 던지도록 설정된 MockJourneyMemoService
   - When: updateMemo(journeyId:memo:) 호출
   - Then: onError가 호출되고 fetchMemos는 호출되지 않는지 확인합니다.
   */
  func test_updateMemo_failure_callsOnErrorAndDoesNotReloadMemos() async {
    let journeyId = "journey-id"
    let memo = makeJourneyMemo()
    mockJourneyMemoService.stubbedUpdateMemoError = MockLocalizedJourneyMemoError.updateFailed
    
    var receivedErrorMessage: String?
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.updateMemo(journeyId: journeyId, memo: memo)
    
    XCTAssertEqual(mockJourneyMemoService.updateMemoCallCount, 1)
    XCTAssertEqual(mockJourneyMemoService.fetchMemosCallCount, 0)
    XCTAssertEqual(receivedErrorMessage, "메모 수정에 실패했습니다.")
  }
  
  /*
   메모 삭제 성공 시 deleteMemo 호출 후 메모 목록을 다시 불러오는지 검증하는 테스트
   - Given: deleteMemo는 성공하고 fetchMemos가 빈 배열을 반환하도록 설정된 MockJourneyMemoService
   - When: deleteMemo(journeyId:memoId:) 호출
   - Then: deleteMemo와 fetchMemos가 각각 1회 호출되고, onMemosChanged가 빈 배열로 호출되는지 확인합니다.
   */
  func test_deleteMemo_success_deletesMemoAndReloadsMemos() async {
    let journeyId = "journey-id"
    let memoId = "memo-id"
    mockJourneyMemoService.stubbedFetchMemosResult = []
    
    var receivedMemos: [JourneyMemo] = [makeJourneyMemo()]
    
    sut.onMemosChanged = { memos in
      receivedMemos = memos
    }
    
    await sut.deleteMemo(journeyId: journeyId, memoId: memoId)
    
    XCTAssertEqual(mockJourneyMemoService.deleteMemoCallCount, 1)
    XCTAssertEqual(mockJourneyMemoService.lastDeleteJourneyId, journeyId)
    XCTAssertEqual(mockJourneyMemoService.lastDeletedMemoId, memoId)
    XCTAssertEqual(mockJourneyMemoService.fetchMemosCallCount, 1)
    XCTAssertEqual(receivedMemos, [])
  }
  
  /*
   메모 삭제 실패 시 onError가 호출되고 메모 목록을 다시 불러오지 않는지 검증하는 테스트
   - Given: deleteMemo가 LocalizedError를 던지도록 설정된 MockJourneyMemoService
   - When: deleteMemo(journeyId:memoId:) 호출
   - Then: onError가 호출되고 fetchMemos는 호출되지 않는지 확인합니다.
   */
  func test_deleteMemo_failure_callsOnErrorAndDoesNotReloadMemos() async {
    let journeyId = "journey-id"
    let memoId = "memo-id"
    mockJourneyMemoService.stubbedDeleteMemoError = MockLocalizedJourneyMemoError.deleteFailed
    
    var receivedErrorMessage: String?
    
    sut.onError = { message in
      receivedErrorMessage = message
    }
    
    await sut.deleteMemo(journeyId: journeyId, memoId: memoId)
    
    XCTAssertEqual(mockJourneyMemoService.deleteMemoCallCount, 1)
    XCTAssertEqual(mockJourneyMemoService.fetchMemosCallCount, 0)
    XCTAssertEqual(receivedErrorMessage, "메모 삭제에 실패했습니다.")
  }
}

// MARK: - Helper
private extension JourneyViewModelTests {
  func makeReadingJourney() -> ReadingJourney {
    ReadingJourney(
      id: "journey-id",
      status: .reading,
      departureAirport: makeDepartureAirport(),
      arrivalAirport: makeArrivalAirport(),
      distanceKm: 540,
      remainingDistanceKm: 300,
      book: makeBookInfo(),
      reason: nil,
      startedAt: Date(timeIntervalSince1970: 1_700_000_000),
      finishedAt: nil,
      currentPage: 120,
      progressUpdatedAt: Date(timeIntervalSince1970: 1_700_000_100),
      review: nil,
      createdAt: Date(timeIntervalSince1970: 1_700_000_000),
      updatedAt: nil,
      lastUpdatedAt: Date(timeIntervalSince1970: 1_700_000_200)
    )
  }
  
  func makeJourneyMemo() -> JourneyMemo {
    JourneyMemo(
      id: "memo-id",
      content: "인상 깊은 문장입니다.",
      page: 120,
      createdAt: Date(timeIntervalSince1970: 1_700_000_300),
      updatedAt: Date(timeIntervalSince1970: 1_700_000_400)
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
      description: "test"
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
