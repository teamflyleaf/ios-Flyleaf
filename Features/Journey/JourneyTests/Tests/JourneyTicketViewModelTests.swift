//
//  JourneyTicketViewModelTests.swift
//  Journey
//
//  Created by 여성일 on 3/20/26.
//

import XCTest
@testable import Core
@testable import JourneyFeature
@testable import JourneyTesting

final class JourneyTicketViewModelTests: XCTestCase {
  private var sut: JourneyTicketViewModel!
  private var mockReadingJourneyService: MockReadingJourneyService!
  private var payload: JourneyPayload!

  override func setUp() {
    super.setUp()
    mockReadingJourneyService = MockReadingJourneyService()
    payload = makeJourneyPayload()
    sut = JourneyTicketViewModel(
      payload: payload,
      readingJourneyService: mockReadingJourneyService
    )
  }

  override func tearDown() {
    sut = nil
    payload = nil
    mockReadingJourneyService = nil
    super.tearDown()
  }

  /*
   업로드 성공 시 로딩 상태 콜백과 성공 콜백이 올바르게 호출되는지 검증하는 테스트
   - Given: createJourney가 성공 결과를 반환하도록 설정된 MockReadingJourneyService
   - When: uploadReadingJourney() 호출
   - Then: onUploadStateChanged는 true/false 순서로 호출되고, onUploadSuccess가 호출되며, onError는 호출되지 않는지 확인합니다.
   */
  func test_uploadReadingJourney_success_callsLoadingStateAndSuccess() async {
    let expectedJourney = makeReadingJourney()
    mockReadingJourneyService.stubbedCreateJourneyResult = expectedJourney

    var loadingStates: [Bool] = []
    var receivedJourney: ReadingJourney?
    var receivedErrorMessage: String?

    sut.onUploadStateChanged = { isLoading in
      loadingStates.append(isLoading)
    }

    sut.onUploadSuccess = { journey in
      receivedJourney = journey
    }

    sut.onError = { message in
      receivedErrorMessage = message
    }

    await sut.uploadReadingJourney()

    XCTAssertEqual(mockReadingJourneyService.createJourneyCallCount, 1)
    XCTAssertEqual(mockReadingJourneyService.lastJourneyPayload?.book.title, payload.book.title)
    XCTAssertEqual(loadingStates, [true, false])
    XCTAssertEqual(receivedJourney, expectedJourney)
    XCTAssertNil(receivedErrorMessage)
  }

  /*
   업로드 실패 시 로딩 상태 콜백과 에러 콜백이 올바르게 호출되는지 검증하는 테스트
   - Given: createJourney가 에러를 던지도록 설정된 MockReadingJourneyService
   - When: uploadReadingJourney() 호출
   - Then: onUploadStateChanged는 true/false 순서로 호출되고, onError가 호출되며, onUploadSuccess는 호출되지 않는지 확인합니다.
   */
  func test_uploadReadingJourney_failure_callsLoadingStateAndError() async {
    mockReadingJourneyService.stubbedCreateJourneyError = MockLocalizedReadingJourneyError.fetchFailed

    var loadingStates: [Bool] = []
    var receivedJourney: ReadingJourney?
    var receivedErrorMessage: String?

    sut.onUploadStateChanged = { isLoading in
      loadingStates.append(isLoading)
    }

    sut.onUploadSuccess = { journey in
      receivedJourney = journey
    }

    sut.onError = { message in
      receivedErrorMessage = message
    }

    await sut.uploadReadingJourney()

    XCTAssertEqual(mockReadingJourneyService.createJourneyCallCount, 1)
    XCTAssertEqual(loadingStates, [true, false])
    XCTAssertNil(receivedJourney)
    XCTAssertEqual(receivedErrorMessage, "독서 여행을 불러오지 못했습니다.")
  }

  /*
   LocalizedError가 아닌 일반 에러가 발생한 경우 기본 에러 메시지를 반환하는지 검증하는 테스트
   - Given: createJourney가 일반 Error를 던지도록 설정된 MockReadingJourneyService
   - When: uploadReadingJourney() 호출
   - Then: onError가 기본 메시지로 호출되는지 확인합니다.
   */
  func test_uploadReadingJourney_nonLocalizedError_callsDefaultErrorMessage() async {
    mockReadingJourneyService.stubbedCreateJourneyError = MockReadingJourneyError.failed

    var receivedErrorMessage: String?

    sut.onError = { message in
      receivedErrorMessage = message
    }

    await sut.uploadReadingJourney()

    XCTAssertEqual(receivedErrorMessage, "독서 여행 저장에 실패했습니다.")
  }
}

// MARK: - Helper
private extension JourneyTicketViewModelTests {
  func makeJourneyPayload() -> JourneyPayload {
    JourneyPayload(
      book: makeBookInfo(),
      startDate: Date(timeIntervalSince1970: 1_700_000_000),
      currentPage: 120,
      departureAirport: makeDepartureAirport(),
      destinationAirport: makeArrivalAirport()
    )
  }

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

  func makeBookInfo() -> BookInfo {
    BookInfo(
      isbn13: "9788937460616",
      title: "테스트 도서",
      author: "테스트 작가",
      publisher: "테스트 출판사",
      itemPage: 584,
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
