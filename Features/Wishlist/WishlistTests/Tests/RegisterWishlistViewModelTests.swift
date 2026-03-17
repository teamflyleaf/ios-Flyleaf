//
//  RegisterWishlistViewModelTests.swift
//  Wishlist
//
//  Created by 여성일 on 3/18/26.
//

import XCTest
@testable import Core
@testable import WishlistFeature
@testable import WishlistTesting

final class RegisterWishlistViewModelTests: XCTestCase {
  private var sut: RegisterWishlistViewModel!

  override func setUp() {
    super.setUp()
    sut = RegisterWishlistViewModel()
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  /*
   책 선택 시 ViewModel이 selectedBook을 업데이트하고 콜백을 호출하는지 검증하는 테스트
   - Given: onSelectedBookChanged 콜백이 등록된 ViewModel
   - When: updateSelectedBook 호출
   - Then: selectedBook이 업데이트되고 콜백이 호출되는지 확인합니다.
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
   이유 텍스트 입력 시 ViewModel이 값을 정상적으로 업데이트하는지 검증하는 테스트
   - Given: 초기 상태의 ViewModel
   - When: updateReasonText 호출
   - Then: reasonText가 입력값으로 변경되는지 확인합니다.
   */
  func test_updateReasonText_updatesReasonText() {
    sut.updateReasonText("읽고 싶은 이유")

    XCTAssertEqual(sut.reasonText, "읽고 싶은 이유")
  }

  /*
   출발 공항 선택 시 ViewModel이 departureAirport를 업데이트하고 콜백을 호출하는지 검증하는 테스트
   - Given: onSelectDepartureChanged 콜백이 등록된 ViewModel
   - When: updateDepartureAirport 호출
   - Then: departureAirport가 업데이트되고 콜백이 호출되는지 확인합니다.
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
   - Then: destinationAirport가 업데이트되고 콜백이 호출되는지 확인합니다.
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
   도착 공항 선택 가능 여부가 출발 공항 선택 여부에 따라 달라지는지 검증하는 테스트
   - Given: 출발 공항이 선택되지 않은 상태
   - When: canSelectDestinationAirport 호출
   - Then: false를 반환하는지 확인합니다.
   */
  func test_canSelectDestinationAirport_returnsFalse_whenDepartureIsNil() {
    XCTAssertFalse(sut.canSelectDestinationAirport())
  }

  /*
   도착 공항 선택 가능 여부가 출발 공항 선택 여부에 따라 달라지는지 검증하는 테스트
   - Given: 출발 공항이 선택된 상태
   - When: canSelectDestinationAirport 호출
   - Then: true를 반환하는지 확인합니다.
   */
  func test_canSelectDestinationAirport_returnsTrue_whenDepartureExists() {
    sut.updateDepartureAirport(makeDepartureAirport())

    XCTAssertTrue(sut.canSelectDestinationAirport())
  }

  /*
   도착 공항 중복 선택 방지 로직이 정상 동작하는지 검증하는 테스트
   - Given: destinationAirport가 설정된 상태
   - When: 동일한 공항을 비교
   - Then: true를 반환하는지 확인합니다.
   */
  func test_isSameAsDestination_returnsTrue_whenIATAIsSame() {
    let airport = makeDestinationAirport()
    sut.updateDestinationAirport(airport)

    XCTAssertTrue(sut.isSameAsDestination(airport))
  }

  /*
   도착 공항 중복 선택 방지 로직이 정상 동작하는지 검증하는 테스트
   - Given: destinationAirport가 설정된 상태
   - When: 다른 공항을 비교
   - Then: false를 반환하는지 확인합니다.
   */
  func test_isSameAsDestination_returnsFalse_whenIATAIsDifferent() {
    sut.updateDestinationAirport(makeDestinationAirport())

    XCTAssertFalse(sut.isSameAsDestination(makeDepartureAirport()))
  }

  /*
   출발 공항 중복 선택 방지 로직이 정상 동작하는지 검증하는 테스트
   - Given: departureAirport가 설정된 상태
   - When: 동일한 공항을 비교
   - Then: true를 반환하는지 확인합니다.
   */
  func test_isSameAsDeparture_returnsTrue_whenIATAIsSame() {
    let airport = makeDepartureAirport()
    sut.updateDepartureAirport(airport)

    XCTAssertTrue(sut.isSameAsDeparture(airport))
  }

  /*
   출발 공항 중복 선택 방지 로직이 정상 동작하는지 검증하는 테스트
   - Given: departureAirport가 설정된 상태
   - When: 다른 공항을 비교
   - Then: false를 반환하는지 확인합니다.
   */
  func test_isSameAsDeparture_returnsFalse_whenIATAIsDifferent() {
    sut.updateDepartureAirport(makeDepartureAirport())

    XCTAssertFalse(sut.isSameAsDeparture(makeDestinationAirport()))
  }
}

// MARK: - Helper
private extension RegisterWishlistViewModelTests {
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
}
