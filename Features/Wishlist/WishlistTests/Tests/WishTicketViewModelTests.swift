//
//  WishTicketViewModelTests.swift
//  Wishlist
//
//  Created by 여성일 on 3/18/26.
//

import XCTest
@testable import Core
@testable import WishlistFeature
@testable import WishlistTesting

final class WishTicketViewModelTests: XCTestCase {
  private var sut: WishTicketViewModel!
  private var mockReadingJourneyService: MockReadingJourneyService!

  override func setUp() {
    super.setUp()
    mockReadingJourneyService = MockReadingJourneyService()
  }

  override func tearDown() {
    sut = nil
    mockReadingJourneyService = nil
    super.tearDown()
  }

  /*
   업로드 성공 시 ViewModel이 업로드 상태 변경과 성공 콜백을 순서대로 호출하는지 검증하는 테스트
   - Given: 성공 결과를 반환하도록 설정된 MockReadingJourneyService와 WishTicketViewModel
   - When: uploadReadingJourney() 호출
   - Then: onUploadStateChanged는 true/false 순서로 호출되고, onUploadSuccess가 호출되며, onError는 호출되지 않는지 확인합니다.
   */
  func test_uploadReadingJourney_success_callsUploadStateChanged_andOnUploadSuccess() async {
    let payload = makePayload()
    let expectedJourney = makeReadingJourney()
    mockReadingJourneyService.stubbedCreateWishlistJourneyResult = expectedJourney

    sut = WishTicketViewModel(
      payload: payload,
      readingJourneyService: mockReadingJourneyService
    )

    var receivedStates: [Bool] = []
    var receivedJourney: ReadingJourney?
    var receivedErrorMessage: String?

    sut.onUploadStateChanged = { isLoading in
      receivedStates.append(isLoading)
    }

    sut.onUploadSuccess = { journey in
      receivedJourney = journey
    }

    sut.onError = { message in
      receivedErrorMessage = message
    }

    await sut.uploadReadingJourney()

    XCTAssertEqual(mockReadingJourneyService.createWishlistJourneyCallCount, 1)
    XCTAssertEqual(mockReadingJourneyService.lastPayload?.book.isbn13, payload.book.isbn13)
    XCTAssertEqual(mockReadingJourneyService.lastPayload?.departure.iata, payload.departure.iata)
    XCTAssertEqual(mockReadingJourneyService.lastPayload?.destination.iata, payload.destination.iata)
    XCTAssertEqual(mockReadingJourneyService.lastPayload?.reason, payload.reason)

    XCTAssertEqual(receivedStates, [true, false])
    XCTAssertEqual(receivedJourney, expectedJourney)
    XCTAssertNil(receivedErrorMessage)
  }

  /*
   업로드 실패 시 ViewModel이 업로드 상태 변경과 에러 콜백을 순서대로 호출하는지 검증하는 테스트
   - Given: 실패를 반환하도록 설정된 MockReadingJourneyService와 WishTicketViewModel
   - When: uploadReadingJourney() 호출
   - Then: onUploadStateChanged는 true/false 순서로 호출되고, onError가 호출되며, onUploadSuccess는 호출되지 않는지 확인합니다.
   */
  func test_uploadReadingJourney_failure_callsUploadStateChanged_andOnError() async {
    let payload = makePayload()
    mockReadingJourneyService.stubbedCreateWishlistJourneyError = MockReadingJourneyError.failed

    sut = WishTicketViewModel(
      payload: payload,
      readingJourneyService: mockReadingJourneyService
    )

    var receivedStates: [Bool] = []
    var receivedJourney: ReadingJourney?
    var receivedErrorMessage: String?

    sut.onUploadStateChanged = { isLoading in
      receivedStates.append(isLoading)
    }

    sut.onUploadSuccess = { journey in
      receivedJourney = journey
    }

    sut.onError = { message in
      receivedErrorMessage = message
    }

    await sut.uploadReadingJourney()

    XCTAssertEqual(mockReadingJourneyService.createWishlistJourneyCallCount, 1)
    XCTAssertEqual(receivedStates, [true, false])
    XCTAssertNil(receivedJourney)
    XCTAssertEqual(receivedErrorMessage, "독서 여행 저장에 실패했습니다.")
  }

  /*
   업로드 실패 시 LocalizedError의 errorDescription이 존재하면 해당 메시지를 전달하는지 검증하는 테스트
   - Given: LocalizedError를 반환하도록 설정된 MockReadingJourneyService와 WishTicketViewModel
   - When: uploadReadingJourney() 호출
   - Then: onError가 LocalizedError의 errorDescription으로 호출되는지 확인합니다.
   */
  func test_uploadReadingJourney_failure_usesLocalizedErrorDescription_whenAvailable() async {
    let payload = makePayload()
    mockReadingJourneyService.stubbedCreateWishlistJourneyError = MockLocalizedReadingJourneyError.custom

    sut = WishTicketViewModel(
      payload: payload,
      readingJourneyService: mockReadingJourneyService
    )

    var receivedErrorMessage: String?

    sut.onError = { message in
      receivedErrorMessage = message
    }

    await sut.uploadReadingJourney()

    XCTAssertEqual(receivedErrorMessage, "중복된 독서 여행입니다.")
  }
}

// MARK: - Helper
private extension WishTicketViewModelTests {
  func makePayload() -> WishlistTicketPayload {
    WishlistTicketPayload(
      book: makeBookInfo(),
      departure: makeDepartureAirport(),
      destination: makeDestinationAirport(),
      reason: "표지가 예뻐서 읽고 싶어요."
    )
  }

  func makeBookInfo() -> BookInfo {
    BookInfo(
      isbn13: "9788937460616",
      title: "설국",
      author: "가와바타 야스나리",
      publisher: "민음사",
      itemPage: 176,
      cover: "https://example.com/book.jpg",
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

  func makeDestinationAirport() -> AirportInfo {
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

  func makeReadingJourney() -> ReadingJourney {
    ReadingJourney(
      id: "journey-id",
      status: .wishlist,
      departureAirport: makeDepartureAirport(),
      arrivalAirport: makeDestinationAirport(),
      distanceKm: 540,
      remainingDistanceKm: 540,
      book: makeBookInfo(),
      reason: "표지가 예뻐서 읽고 싶어요.",
      startedAt: nil,
      finishedAt: nil,
      currentPage: nil,
      progressUpdatedAt: nil,
      review: nil,
      createdAt: Date(),
      updatedAt: nil,
      lastUpdatedAt: Date()
    )
  }
}
