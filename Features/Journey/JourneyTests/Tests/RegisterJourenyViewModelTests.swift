//
//  RegisterJourenyViewModelTests.swift
//  Journey
//
//  Created by 여성일 on 3/20/26.
//

import XCTest
@testable import Core
@testable import JourneyFeature
@testable import JourneyTesting

final class RegisterJourenyViewModelTests: XCTestCase {
  private var sut: RegisterJourenyViewModel!
  
  override func setUp() {
    super.setUp()
    sut = RegisterJourenyViewModel()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  /*
   책 선택 시 selectedBook이 업데이트되고 onSelectedBookChanged가 호출되는지 검증하는 테스트
   - Given: onSelectedBookChanged 콜백이 등록된 ViewModel
   - When: updateSelectedBook(_:) 호출
   - Then: selectedBook이 업데이트되고 선택된 책 정보가 콜백으로 전달되는지 확인합니다.
   */
  func test_updateSelectedBook_updatesSelectedBook_andCallsOnSelectedBookChanged() {
    let book = makeBookInfo()
    let expectation = expectation(description: "onSelectedBookChanged called")
    
    var receivedBook: BookInfo?
    
    sut.onSelectedBookChanged = { item in
      receivedBook = item
      expectation.fulfill()
    }
    
    sut.updateSelectedBook(book)
    
    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(sut.selectedBook, book)
    XCTAssertEqual(receivedBook, book)
  }
  
  /*
   시작일만 선택된 경우 다음 버튼이 비활성화 상태인지 검증하는 테스트
   - Given: onBookStepNextButtonEnabledChanged 콜백이 등록된 ViewModel
   - When: updateStartDate(_:) 호출
   - Then: currentPage가 없으므로 false가 전달되는지 확인합니다.
   */
  func test_updateStartDate_whenCurrentPageIsNil_callsNextButtonDisabled() {
    let expectation = expectation(description: "onBookStepNextButtonEnabledChanged called")
    
    var receivedIsEnabled: Bool?
    
    sut.onBookStepNextButtonEnabledChanged = { isEnabled in
      receivedIsEnabled = isEnabled
      expectation.fulfill()
    }
    
    sut.updateStartDate(Date())
    
    wait(for: [expectation], timeout: 1.0)
    XCTAssertNotNil(sut.startDate)
    XCTAssertEqual(receivedIsEnabled, false)
  }
  
  /*
   시작일과 읽은 페이지 수가 모두 유효한 경우 다음 버튼이 활성화되는지 검증하는 테스트
   - Given: 시작일이 먼저 입력된 ViewModel
   - When: updateCurrentPage(_:) 호출
   - Then: onBookStepNextButtonEnabledChanged에 true가 전달되는지 확인합니다.
   */
  func test_updateCurrentPage_whenStartDateExists_andPageIsGreaterThanZero_callsNextButtonEnabled() {
    let expectation = expectation(description: "onBookStepNextButtonEnabledChanged called twice")
    expectation.expectedFulfillmentCount = 2
    
    var receivedStates: [Bool] = []
    
    sut.onBookStepNextButtonEnabledChanged = { isEnabled in
      receivedStates.append(isEnabled)
      expectation.fulfill()
    }
    
    sut.updateStartDate(Date())
    sut.updateCurrentPage(10)
    
    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(sut.currentPage, 10)
    XCTAssertEqual(receivedStates, [false, true])
  }
  
  /*
   읽은 페이지 수가 0인 경우 다음 버튼이 비활성화 상태인지 검증하는 테스트
   - Given: 시작일이 입력된 ViewModel
   - When: updateCurrentPage(0) 호출
   - Then: onBookStepNextButtonEnabledChanged에 false가 전달되는지 확인합니다.
   */
  func test_updateCurrentPage_whenPageIsZero_callsNextButtonDisabled() {
    let expectation = expectation(description: "onBookStepNextButtonEnabledChanged called twice")
    expectation.expectedFulfillmentCount = 2
    
    var receivedStates: [Bool] = []
    
    sut.onBookStepNextButtonEnabledChanged = { isEnabled in
      receivedStates.append(isEnabled)
      expectation.fulfill()
    }
    
    sut.updateStartDate(Date())
    sut.updateCurrentPage(0)
    
    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(sut.currentPage, 0)
    XCTAssertEqual(receivedStates, [false, false])
  }
  
  /*
   출발 공항 선택 시 departureAirport가 업데이트되고 onSelectDepartureChanged가 호출되는지 검증하는 테스트
   - Given: onSelectDepartureChanged 콜백이 등록된 ViewModel
   - When: updateDepartureAirport(_:) 호출
   - Then: departureAirport가 업데이트되고 선택된 공항 정보가 콜백으로 전달되는지 확인합니다.
   */
  func test_updateDepartureAirport_updatesDepartureAirport_andCallsOnSelectDepartureChanged() {
    let airport = makeDepartureAirport()
    let expectation = expectation(description: "onSelectDepartureChanged called")
    
    var receivedAirport: AirportInfo?
    
    sut.onSelectDepartureChanged = { item in
      receivedAirport = item
      expectation.fulfill()
    }
    
    sut.updateDepartureAirport(airport)
    
    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(sut.departureAirport, airport)
    XCTAssertEqual(receivedAirport, airport)
  }
  
  /*
   도착 공항 선택 시 destinationAirport가 업데이트되고 onSelectDestinationChanged가 호출되는지 검증하는 테스트
   - Given: onSelectDestinationChanged 콜백이 등록된 ViewModel
   - When: updateDestinationAirport(_:) 호출
   - Then: destinationAirport가 업데이트되고 선택된 공항 정보가 콜백으로 전달되는지 확인합니다.
   */
  func test_updateDestinationAirport_updatesDestinationAirport_andCallsOnSelectDestinationChanged() {
    let airport = makeArrivalAirport()
    let expectation = expectation(description: "onSelectDestinationChanged called")
    
    var receivedAirport: AirportInfo?
    
    sut.onSelectDestinationChanged = { item in
      receivedAirport = item
      expectation.fulfill()
    }
    
    sut.updateDestinationAirport(airport)
    
    wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(sut.destinationAirport, airport)
    XCTAssertEqual(receivedAirport, airport)
  }
  
  /*
   출발 공항이 선택되지 않은 경우 도착 공항 선택이 불가능한지 검증하는 테스트
   - Given: departureAirport가 nil인 ViewModel
   - When: canSelectDestinationAirport() 호출
   - Then: false를 반환하는지 확인합니다.
   */
  func test_canSelectDestinationAirport_whenDepartureAirportIsNil_returnsFalse() {
    XCTAssertFalse(sut.canSelectDestinationAirport())
  }
  
  /*
   출발 공항이 선택된 경우 도착 공항 선택이 가능한지 검증하는 테스트
   - Given: departureAirport가 설정된 ViewModel
   - When: canSelectDestinationAirport() 호출
   - Then: true를 반환하는지 확인합니다.
   */
  func test_canSelectDestinationAirport_whenDepartureAirportExists_returnsTrue() {
    sut.updateDepartureAirport(makeDepartureAirport())
    
    XCTAssertTrue(sut.canSelectDestinationAirport())
  }
  
  /*
   현재 도착 공항과 동일한 공항인지 판별하는지 검증하는 테스트
   - Given: destinationAirport가 설정된 ViewModel
   - When: 같은 IATA 코드를 가진 공항으로 isSameAsDestination(_:) 호출
   - Then: true를 반환하는지 확인합니다.
   */
  func test_isSameAsDestination_whenSameAirport_returnsTrue() {
    let airport = makeArrivalAirport()
    sut.updateDestinationAirport(airport)
    
    XCTAssertTrue(sut.isSameAsDestination(airport))
  }
  
  /*
   현재 도착 공항과 다른 공항인지 판별하는지 검증하는 테스트
   - Given: destinationAirport가 설정된 ViewModel
   - When: 다른 IATA 코드를 가진 공항으로 isSameAsDestination(_:) 호출
   - Then: false를 반환하는지 확인합니다.
   */
  func test_isSameAsDestination_whenDifferentAirport_returnsFalse() {
    sut.updateDestinationAirport(makeArrivalAirport())
    
    XCTAssertFalse(sut.isSameAsDestination(makeDepartureAirport()))
  }
  
  /*
   현재 출발 공항과 동일한 공항인지 판별하는지 검증하는 테스트
   - Given: departureAirport가 설정된 ViewModel
   - When: 같은 IATA 코드를 가진 공항으로 isSameAsDeparture(_:) 호출
   - Then: true를 반환하는지 확인합니다.
   */
  func test_isSameAsDeparture_whenSameAirport_returnsTrue() {
    let airport = makeDepartureAirport()
    sut.updateDepartureAirport(airport)
    
    XCTAssertTrue(sut.isSameAsDeparture(airport))
  }
  
  /*
   현재 출발 공항과 다른 공항인지 판별하는지 검증하는 테스트
   - Given: departureAirport가 설정된 ViewModel
   - When: 다른 IATA 코드를 가진 공항으로 isSameAsDeparture(_:) 호출
   - Then: false를 반환하는지 확인합니다.
   */
  func test_isSameAsDeparture_whenDifferentAirport_returnsFalse() {
    sut.updateDepartureAirport(makeDepartureAirport())
    
    XCTAssertFalse(sut.isSameAsDeparture(makeArrivalAirport()))
  }
}

// MARK: - Helper
private extension RegisterJourenyViewModelTests {
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
