//
//  CheckInWishTicketViewModelTests.swift
//  Wishlist
//
//  Created by 여성일 on 3/21/26.
//

import XCTest
@testable import Core
@testable import WishlistFeature
@testable import WishlistTesting

final class CheckInWishTicketViewModelTests: XCTestCase {
  private var sut: CheckInWishTicketViewModel!
  private var mockReadingJourneyService: MockReadingJourneyService!
  
  override func setUp() {
    super.setUp()
    mockReadingJourneyService = MockReadingJourneyService()
    sut = CheckInWishTicketViewModel(
      journey: makeWishlistJourney(),
      readingJourneyService: mockReadingJourneyService
    )
  }
  
  override func tearDown() {
    sut = nil
    mockReadingJourneyService = nil
    super.tearDown()
  }
  
  /*
   payload가 기존 wishlist journey 기반으로 정상 생성되는지 검증하는 테스트
   - Given: wishlist 상태의 ReadingJourney
   - When: payload 프로퍼티 조회
   - Then: journey의 book, departure, destination이 그대로 전달되고 currentPage는 0인지 확인합니다.
   */
  func test_payload_returnsJourneyBasedPayload() {
    let payload = sut.payload
    
    XCTAssertEqual(payload.book, sut.journey.book)
    XCTAssertEqual(payload.departureAirport, sut.journey.departureAirport)
    XCTAssertEqual(payload.destinationAirport, sut.journey.arrivalAirport)
    XCTAssertEqual(payload.currentPage, 0)
  }
  
  /*
   체크인(uploadReadingJourney)이 성공했을 때 서비스 호출 및 콜백 순서가 정상 동작하는지 검증하는 테스트
   - Given: updateJourneyStatusToReading 성공 응답을 반환하는 MockReadingJourneyService
   - When: uploadReadingJourney 호출
   - Then:
     - 서비스가 1번 호출되는지
     - 전달된 journeyId, currentPage가 올바른지
     - 로딩 상태가 [true, false] 순서로 변경되는지
     - onUploadSuccess가 호출되고 반환된 journey가 전달되는지 확인합니다.
   */
  func test_uploadReadingJourney_success_callsService_andEmitsCallbacksInOrder() async {
    let updatedJourney = makeReadingJourney(
      id: sut.journey.id,
      status: .reading
    )
    mockReadingJourneyService.stubbedUpdatedJourneyResult = updatedJourney
    
    let uploadStateExpectation = expectation(description: "upload state changed twice")
    uploadStateExpectation.expectedFulfillmentCount = 2
    
    let successExpectation = expectation(description: "upload success called")
    
    var receivedStates: [Bool] = []
    var receivedJourney: ReadingJourney?
    
    sut.onUploadStateChanged = { isLoading in
      receivedStates.append(isLoading)
      uploadStateExpectation.fulfill()
    }
    
    sut.onUploadSuccess = { journey in
      receivedJourney = journey
      successExpectation.fulfill()
    }
    
    await sut.uploadReadingJourney()
    
    await fulfillment(of: [uploadStateExpectation, successExpectation], timeout: 1.0)
    
    XCTAssertEqual(mockReadingJourneyService.updateJourneyStatusToReadingCallCount, 1)
    XCTAssertEqual(mockReadingJourneyService.receivedJourneyId, sut.journey.id)
    XCTAssertEqual(mockReadingJourneyService.receivedCurrentPage, 0)
    XCTAssertEqual(receivedStates, [true, false])
    XCTAssertEqual(receivedJourney, updatedJourney)
  }
  
  /*
   체크인(uploadReadingJourney)이 실패했을 때 에러 처리 및 로딩 상태가 정상 동작하는지 검증하는 테스트
   - Given: 에러를 던지도록 설정된 MockReadingJourneyService
   - When: uploadReadingJourney 호출
   - Then:
     - 서비스가 1번 호출되는지
     - 로딩 상태가 [true, false] 순서로 변경되는지
     - onError가 호출되고 에러 메시지가 전달되는지 확인합니다.
   */
  func test_uploadReadingJourney_failure_callsOnError_andTogglesLoadingState() async {
    mockReadingJourneyService.stubbedUpdateJourneyStatusToReadingError = MockLocalizedReadingJourneyError.custom
    
    let uploadStateExpectation = expectation(description: "upload state changed twice")
    uploadStateExpectation.expectedFulfillmentCount = 2
    
    let errorExpectation = expectation(description: "error called")
    
    var receivedStates: [Bool] = []
    var receivedMessage: String?
    
    sut.onUploadStateChanged = { isLoading in
      receivedStates.append(isLoading)
      uploadStateExpectation.fulfill()
    }
    
    sut.onError = { message in
      receivedMessage = message
      errorExpectation.fulfill()
    }
    
    await sut.uploadReadingJourney()
    
    await fulfillment(of: [uploadStateExpectation, errorExpectation], timeout: 1.0)
    
    XCTAssertEqual(mockReadingJourneyService.updateJourneyStatusToReadingCallCount, 1)
    XCTAssertEqual(receivedStates, [true, false])
    XCTAssertEqual(receivedMessage, "중복된 독서 여행입니다.")
  }
}

// MARK: - Helper
private extension CheckInWishTicketViewModelTests {
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
  
  func makeReadingJourney(
    id: String = "journey-id",
    status: ReadingJourneyStatusType = .reading
  ) -> ReadingJourney {
    ReadingJourney(
      id: id,
      status: status,
      departureAirport: makeDepartureAirport(),
      arrivalAirport: makeArrivalAirport(),
      distanceKm: 540,
      remainingDistanceKm: 540,
      book: makeBookInfo(),
      reason: "읽고 싶어서",
      startedAt: Date(timeIntervalSince1970: 1_700_000_100),
      finishedAt: nil,
      currentPage: 0,
      progressUpdatedAt: Date(timeIntervalSince1970: 1_700_000_100),
      review: nil,
      createdAt: Date(timeIntervalSince1970: 1_700_000_000),
      updatedAt: nil,
      lastUpdatedAt: Date(timeIntervalSince1970: 1_700_000_100)
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
