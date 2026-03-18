//
//  RegisterHistoryViewModelTests.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import XCTest
@testable import HistoryFeature
@testable import Core
@testable import HistoryTesting

final class RegisterHistoryViewModelTests: XCTestCase {
  private var sut: RegisterHistoryViewModel!
  private var mockReadingJourneyService: MockReadingJourneyService!
  
  override func setUp() {
    super.setUp()
    mockReadingJourneyService = MockReadingJourneyService()
    sut = RegisterHistoryViewModel(
      readingJourneyService: mockReadingJourneyService
    )
  }
  
  override func tearDown() {
    sut = nil
    mockReadingJourneyService = nil
    super.tearDown()
  }
  
  /*
   책 선택 시 ViewModel이 selectedBook을 업데이트하고 콜백을 호출하는지 검증하는 테스트
   - Given: onSelectedBookChanged 콜백이 등록된 ViewModel
   - When: updateSelectedBook 호출
   - Then: selectedBook이 업데이트되고 onSelectedBookChanged가 호출되는지 확인합니다.
   */
  func test_updateSelectedBook_updatesSelectedBook_andCallsCallback() {
    let expected = makeBookInfo()
    let exp = expectation(description: "onSelectedBookChanged called")
    
    var received: BookInfo?
    sut.onSelectedBookChanged = { item in
      received = item
      exp.fulfill()
    }
    
    sut.updateSelectedBook(expected)
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(sut.selectedBook, expected)
    XCTAssertEqual(received, expected)
  }
  
  /*
   리뷰 텍스트 입력 시 ViewModel이 reviewText를 업데이트하는지 검증하는 테스트
   - Given: 초기 상태의 ViewModel
   - When: updateReviewText 호출
   - Then: reviewText가 입력값으로 업데이트되는지 확인합니다.
   */
  func test_updateReviewText_updatesReviewText() {
    sut.updateReviewText("좋은 책이었다.")
    
    XCTAssertEqual(sut.reviewText, "좋은 책이었다.")
  }
  
  /*
   출발 공항 선택 시 ViewModel이 departureAirport를 업데이트하고 콜백을 호출하는지 검증하는 테스트
   - Given: onSelectDepartureChanged 콜백이 등록된 ViewModel
   - When: updateDepartureAirport 호출
   - Then: departureAirport가 업데이트되고 onSelectDepartureChanged가 호출되는지 확인합니다.
   */
  func test_updateDepartureAirport_updatesDepartureAirport_andCallsCallback() {
    let expected = makeDepartureAirport()
    let exp = expectation(description: "onSelectDepartureChanged called")
    
    var received: AirportInfo?
    sut.onSelectDepartureChanged = { airport in
      received = airport
      exp.fulfill()
    }
    
    sut.updateDepartureAirport(expected)
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(sut.departureAirport, expected)
    XCTAssertEqual(received, expected)
  }
  
  /*
   도착 공항 선택 시 ViewModel이 destinationAirport를 업데이트하고 콜백을 호출하는지 검증하는 테스트
   - Given: onSelectDestinationChanged 콜백이 등록된 ViewModel
   - When: updateDestinationAirport 호출
   - Then: destinationAirport가 업데이트되고 onSelectDestinationChanged가 호출되는지 확인합니다.
   */
  func test_updateDestinationAirport_updatesDestinationAirport_andCallsCallback() {
    let expected = makeDestinationAirport()
    let exp = expectation(description: "onSelectDestinationChanged called")
    
    var received: AirportInfo?
    sut.onSelectDestinationChanged = { airport in
      received = airport
      exp.fulfill()
    }
    
    sut.updateDestinationAirport(expected)
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(sut.destinationAirport, expected)
    XCTAssertEqual(received, expected)
  }
  
  /*
   시작일만 선택된 상태에서는 다음 버튼이 비활성화 상태인지 검증하는 테스트
   - Given: 시작일만 입력된 ViewModel
   - When: updateStartDate 호출
   - Then: onBookStepNextButtonEnabledChanged에 false가 전달되는지 확인합니다.
   */
  func test_updateStartDate_callsNextButtonStateChanged_withFalse_whenFinishDateIsNil() {
    let exp = expectation(description: "onBookStepNextButtonEnabledChanged called")
    
    var received: Bool?
    sut.onBookStepNextButtonEnabledChanged = { isEnabled in
      received = isEnabled
      exp.fulfill()
    }
    
    sut.updateStartDate(Date())
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(received, false)
    XCTAssertNotNil(sut.startDate)
  }
  
  /*
   시작일과 종료일이 모두 입력되면 다음 버튼이 활성화되는지 검증하는 테스트
   - Given: 시작일이 먼저 입력된 ViewModel
   - When: updateFinishDate 호출
   - Then: onBookStepNextButtonEnabledChanged에 true가 전달되는지 확인합니다.
   */
  func test_updateFinishDate_callsNextButtonStateChanged_withTrue_whenBothDatesExist() {
    let startDate = Date()
    let finishDate = Date().addingTimeInterval(86400)
    
    var receivedStates: [Bool] = []
    let exp = expectation(description: "onBookStepNextButtonEnabledChanged called twice")
    exp.expectedFulfillmentCount = 2
    
    sut.onBookStepNextButtonEnabledChanged = { isEnabled in
      receivedStates.append(isEnabled)
      exp.fulfill()
    }
    
    sut.updateStartDate(startDate)
    sut.updateFinishDate(finishDate)
    
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(receivedStates, [false, true])
    XCTAssertEqual(sut.finishDate, finishDate)
  }
  
  /*
   출발 공항이 없을 때 도착 공항 선택이 불가능한지 검증하는 테스트
   - Given: 출발 공항이 선택되지 않은 ViewModel
   - When: canSelectDestinationAirport 호출
   - Then: false를 반환하는지 확인합니다.
   */
  func test_canSelectDestinationAirport_returnsFalse_whenDepartureAirportIsNil() {
    XCTAssertFalse(sut.canSelectDestinationAirport())
  }
  
  /*
   출발 공항이 있을 때 도착 공항 선택이 가능한지 검증하는 테스트
   - Given: 출발 공항이 선택된 ViewModel
   - When: canSelectDestinationAirport 호출
   - Then: true를 반환하는지 확인합니다.
   */
  func test_canSelectDestinationAirport_returnsTrue_whenDepartureAirportExists() {
    sut.updateDepartureAirport(makeDepartureAirport())
    
    XCTAssertTrue(sut.canSelectDestinationAirport())
  }
  
  /*
   현재 도착 공항과 동일한 공항인지 판별하는 로직이 정상 동작하는지 검증하는 테스트
   - Given: destinationAirport가 설정된 ViewModel
   - When: 같은 iata 코드를 가진 공항을 비교
   - Then: true를 반환하는지 확인합니다.
   */
  func test_isSameAsDestination_returnsTrue_whenIATAIsSame() {
    let airport = makeDestinationAirport()
    sut.updateDestinationAirport(airport)
    
    XCTAssertTrue(sut.isSameAsDestination(airport))
  }
  
  /*
   현재 도착 공항과 다른 공항인지 판별하는 로직이 정상 동작하는지 검증하는 테스트
   - Given: destinationAirport가 설정된 ViewModel
   - When: 다른 iata 코드를 가진 공항을 비교
   - Then: false를 반환하는지 확인합니다.
   */
  func test_isSameAsDestination_returnsFalse_whenIATAIsDifferent() {
    sut.updateDestinationAirport(makeDestinationAirport())
    
    XCTAssertFalse(sut.isSameAsDestination(makeDepartureAirport()))
  }
  
  /*
   현재 출발 공항과 동일한 공항인지 판별하는 로직이 정상 동작하는지 검증하는 테스트
   - Given: departureAirport가 설정된 ViewModel
   - When: 같은 iata 코드를 가진 공항을 비교
   - Then: true를 반환하는지 확인합니다.
   */
  func test_isSameAsDeparture_returnsTrue_whenIATAIsSame() {
    let airport = makeDepartureAirport()
    sut.updateDepartureAirport(airport)
    
    XCTAssertTrue(sut.isSameAsDeparture(airport))
  }
  
  /*
   현재 출발 공항과 다른 공항인지 판별하는 로직이 정상 동작하는지 검증하는 테스트
   - Given: departureAirport가 설정된 ViewModel
   - When: 다른 iata 코드를 가진 공항을 비교
   - Then: false를 반환하는지 확인합니다.
   */
  func test_isSameAsDeparture_returnsFalse_whenIATAIsDifferent() {
    sut.updateDepartureAirport(makeDepartureAirport())
    
    XCTAssertFalse(sut.isSameAsDeparture(makeDestinationAirport()))
  }
  
  /*
   업로드에 필요한 정보가 부족한 경우 에러 콜백을 호출하는지 검증하는 테스트
   - Given: payload를 만들 수 없을 정도로 입력값이 부족한 ViewModel
   - When: uploadReadingJourney 호출
   - Then: 서비스는 호출되지 않고 onError가 호출되는지 확인합니다.
   */
  func test_uploadReadingJourney_callsOnError_whenPayloadIsMissing() async {
    let exp = expectation(description: "onError called")
    var receivedMessage: String?
    
    sut.onError = { message in
      receivedMessage = message
      exp.fulfill()
    }
    
    await sut.uploadReadingJourney()
    
    await fulfillment(of: [exp], timeout: 1.0)
    XCTAssertEqual(mockReadingJourneyService.createHistoryJourneyCallCount, 0)
    XCTAssertEqual(receivedMessage, "히스토리 저장에 필요한 정보가 부족합니다.")
  }
  
  /*
   업로드 성공 시 로딩 상태와 성공 콜백이 올바르게 호출되는지 검증하는 테스트
   - Given: 성공 결과를 반환하도록 설정된 MockReadingJourneyService와 payload 생성이 가능한 ViewModel
   - When: uploadReadingJourney 호출
   - Then: onUploadStateChanged는 true/false 순서로 호출되고 onUploadSuccess가 호출되는지 확인합니다.
   */
  func test_uploadReadingJourney_success_callsUploadStateChanged_andOnUploadSuccess() async {
    let expectedJourney = makeReadingJourney()
    mockReadingJourneyService.stubbedCreateHistoryJourneyResult = expectedJourney
    
    sut.updateSelectedBook(makeBookInfo())
    sut.updateStartDate(makeStartDate())
    sut.updateFinishDate(makeFinishDate())
    sut.updateReviewText("감상평")
    sut.updateDepartureAirport(makeDepartureAirport())
    sut.updateDestinationAirport(makeDestinationAirport())
    
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
    
    XCTAssertEqual(mockReadingJourneyService.createHistoryJourneyCallCount, 1)
    XCTAssertEqual(receivedStates, [true, false])
    XCTAssertEqual(receivedJourney, expectedJourney)
    XCTAssertNil(receivedErrorMessage)
  }
  
  /*
   업로드 실패 시 로딩 상태와 에러 콜백이 올바르게 호출되는지 검증하는 테스트
   - Given: 실패를 반환하도록 설정된 MockReadingJourneyService와 payload 생성이 가능한 ViewModel
   - When: uploadReadingJourney 호출
   - Then: onUploadStateChanged는 true/false 순서로 호출되고 onError가 호출되는지 확인합니다.
   */
  func test_uploadReadingJourney_failure_callsUploadStateChanged_andOnError() async {
    mockReadingJourneyService.stubbedCreateHistoryJourneyError = MockLocalizedReadingJourneyError.custom
    
    sut.updateSelectedBook(makeBookInfo())
    sut.updateStartDate(makeStartDate())
    sut.updateFinishDate(makeFinishDate())
    sut.updateReviewText("감상평")
    sut.updateDepartureAirport(makeDepartureAirport())
    sut.updateDestinationAirport(makeDestinationAirport())
    
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
    
    XCTAssertEqual(mockReadingJourneyService.createHistoryJourneyCallCount, 1)
    XCTAssertEqual(receivedStates, [true, false])
    XCTAssertNil(receivedJourney)
    XCTAssertEqual(receivedErrorMessage, "중복된 독서 여행입니다.")
  }
}

// MARK: - Fixture
private extension RegisterHistoryViewModelTests {
  func makeBookInfo() -> BookInfo {
    BookInfo(
      isbn13: "9788937460616",
      title: "설국",
      author: "가와바타 야스나리",
      publisher: "민음사",
      itemPage: 176,
      cover: "https://example.com/book.jpg"
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
  
  func makeStartDate() -> Date {
    Date(timeIntervalSince1970: 1_710_000_000)
  }
  
  func makeFinishDate() -> Date {
    Date(timeIntervalSince1970: 1_710_086_400)
  }
  
  func makeReadingJourney() -> ReadingJourney {
    ReadingJourney(
      id: "history-journey-id",
      status: .finished,
      departureAirport: makeDepartureAirport(),
      arrivalAirport: makeDestinationAirport(),
      distanceKm: 540,
      remainingDistanceKm: 0,
      book: makeBookInfo(),
      reason: nil,
      startedAt: makeStartDate(),
      finishedAt: makeFinishDate(),
      currentPage: 176,
      progressUpdatedAt: makeFinishDate(),
      review: "감상평",
      createdAt: Date(),
      updatedAt: nil,
      lastUpdatedAt: Date()
    )
  }
}
