//
//  SearchViewModelTests.swift
//  Search
//
//  Created by 여성일 on 3/18/26.
//

import XCTest
@testable import SearchFeature
@testable import Core
@testable import SearchInterface

final class SearchViewModelTests: XCTestCase {
  private var sut: SearchViewModel!
  private var mockBookSearchService: MockBookSearchService!
  private var mockAirportSearchService: MockAirportSearchService!
  private var mockRecentSearchStorage: MockRecentSearchStorage!

  override func setUp() {
    super.setUp()
    mockBookSearchService = MockBookSearchService()
    mockAirportSearchService = MockAirportSearchService()
    mockRecentSearchStorage = MockRecentSearchStorage()
  }

  override func tearDown() {
    sut = nil
    mockBookSearchService = nil
    mockAirportSearchService = nil
    mockRecentSearchStorage = nil
    super.tearDown()
  }

  /*
   검색 타입이 book일 때 placeholder가 올바르게 반환되는지 검증하는 테스트
   - Given: type이 .book인 SearchViewModel
   - When: placeholder 값을 조회
   - Then: 도서 검색용 placeholder 문구가 반환되는지 확인합니다.
   */
  func test_placeholder_returnsBookPlaceholder_whenTypeIsBook() {
    sut = makeSUT(type: .book)

    XCTAssertEqual(sut.placeholder, "검색어를 입력하세요")
  }

  /*
   검색 타입이 departureAirport일 때 placeholder가 올바르게 반환되는지 검증하는 테스트
   - Given: type이 .departureAirport인 SearchViewModel
   - When: placeholder 값을 조회
   - Then: 출발 공항 검색용 placeholder 문구가 반환되는지 확인합니다.
   */
  func test_placeholder_returnsDeparturePlaceholder_whenTypeIsDepartureAirport() {
    sut = makeSUT(type: .departureAirport)

    XCTAssertEqual(sut.placeholder, "출발 공항 검색 (공항명/도시/코드)")
  }

  /*
   검색 타입이 arrivalAirport일 때 placeholder가 올바르게 반환되는지 검증하는 테스트
   - Given: type이 .arrivalAirport인 SearchViewModel
   - When: placeholder 값을 조회
   - Then: 도착 공항 검색용 placeholder 문구가 반환되는지 확인합니다.
   */
  func test_placeholder_returnsArrivalPlaceholder_whenTypeIsArrivalAirport() {
    sut = makeSUT(type: .arrivalAirport)

    XCTAssertEqual(sut.placeholder, "도착 공항 검색 (공항명/도시/코드)")
  }

  /*
   도서 검색 성공 시 ViewModel이 books를 업데이트하고 콜백을 호출하는지 검증하는 테스트
   - Given: 도서 검색 결과가 설정된 MockBookSearchService와 type이 .book인 SearchViewModel
   - When: search(query:) 호출
   - Then: books가 업데이트되고 onBooksChanged가 호출되는지 확인합니다.
   */
  func test_search_book_updatesBooks_whenSearchSucceeds() async {
    sut = makeSUT(type: .book)

    let expectedBooks = [
      makeBookSearchItem(title: "설국"),
      makeBookSearchItem(title: "데미안")
    ]
    mockBookSearchService.stubbedSearchPage = BookSearchPage(
      items: expectedBooks,
      totalResults: 2,
      startIndex: 1,
      itemsPerPage: 10
    )

    let exp = expectation(description: "onBooksChanged called")
    var received: [BookSearchItem] = []

    sut.onBooksChanged = { books in
      guard !books.isEmpty else { return }   // 초기 [] 콜백 무시
      received = books
      exp.fulfill()
    }

    await sut.search(query: "소설")

    await fulfillment(of: [exp], timeout: 1.0)
    XCTAssertEqual(received, expectedBooks)
    XCTAssertEqual(sut.books, expectedBooks)
    XCTAssertEqual(mockBookSearchService.searchBooksCallCount, 1)
    XCTAssertEqual(mockBookSearchService.lastQuery, "소설")
    XCTAssertEqual(mockBookSearchService.lastStart, 1)
  }

  /*
   공항 검색 성공 시 ViewModel이 airports를 업데이트하고 콜백을 호출하는지 검증하는 테스트
   - Given: 공항 검색 결과가 설정된 MockAirportSearchService와 type이 .departureAirport인 SearchViewModel
   - When: search(query:) 호출
   - Then: airports가 업데이트되고 onAirportsChanged가 호출되는지 확인합니다.
   */
  func test_search_airport_updatesAirports_whenSearchSucceeds() async {
    sut = makeSUT(type: .departureAirport)

    let expectedAirports = [
      makeAirport(iata: "CJJ", cityKo: "청주")
    ]
    mockAirportSearchService.stubbedSearchAirports = expectedAirports

    let exp = expectation(description: "onAirportsChanged called")
    var received: [AirportInfo] = []

    sut.onAirportsChanged = { airports in
      guard !airports.isEmpty else { return }   // 초기 [] 콜백 무시
      received = airports
      exp.fulfill()
    }

    await sut.search(query: "청주")

    await fulfillment(of: [exp], timeout: 1.0)
    XCTAssertEqual(received, expectedAirports)
    XCTAssertEqual(sut.airports, expectedAirports)
    XCTAssertEqual(mockAirportSearchService.searchAirportsCallCount, 1)
    XCTAssertEqual(mockAirportSearchService.lastQuery, "청주")
  }

  /*
   검색 수행 시 최근 검색어가 저장되고 다시 로드되는지 검증하는 테스트
   - Given: MockRecentSearchStorage와 type이 .book인 SearchViewModel
   - When: search(query:) 호출
   - Then: 최근 검색어가 저장되고 recentSearches에 반영되는지 확인합니다.
   */
  func test_search_savesRecentSearch() async {
    sut = makeSUT(type: .book)
    mockBookSearchService.stubbedSearchPage = BookSearchPage(
      items: [],
      totalResults: 0,
      startIndex: 1,
      itemsPerPage: 10
    )

    await sut.search(query: "클린 코드")

    XCTAssertEqual(mockRecentSearchStorage.savedQueries.count, 1)
    XCTAssertEqual(mockRecentSearchStorage.savedQueries.first?.query, "클린 코드")
    XCTAssertEqual(mockRecentSearchStorage.savedQueries.first?.type, .book)
    XCTAssertEqual(sut.recentSearches, ["클린 코드"])
  }

  /*
   다음 페이지가 존재할 때 loadNextPage가 다음 도서 검색 결과를 append하는지 검증하는 테스트
   - Given: 두 페이지 분량의 검색 결과가 준비된 MockBookSearchService와 type이 .book인 SearchViewModel
   - When: search(query:) 후 loadNextPage() 호출
   - Then: 두 번째 페이지 결과가 books에 append되는지 확인합니다.
   */
  func test_loadNextPage_appendsBooks_whenHasNextPage() async {
    sut = makeSUT(type: .book)

    mockBookSearchService.stubbedSearchPages = [
      BookSearchPage(
        items: [makeBookSearchItem(title: "책1")],
        totalResults: 2,
        startIndex: 1,
        itemsPerPage: 10
      ),
      BookSearchPage(
        items: [makeBookSearchItem(title: "책2")],
        totalResults: 2,
        startIndex: 2,
        itemsPerPage: 10
      )
    ]

    await sut.search(query: "테스트")
    await sut.loadNextPage()

    XCTAssertEqual(mockBookSearchService.searchBooksCallCount, 2)
    XCTAssertEqual(mockBookSearchService.requestedStarts, [1, 2])
    XCTAssertEqual(sut.books.map(\.title), ["책1", "책2"])
  }

  /*
   검색 타입이 book이 아닐 때 loadNextPage가 동작하지 않는지 검증하는 테스트
   - Given: type이 .departureAirport인 SearchViewModel
   - When: loadNextPage() 호출
   - Then: 도서 검색 서비스가 호출되지 않는지 확인합니다.
   */
  func test_loadNextPage_doesNothing_whenTypeIsNotBook() async {
    sut = makeSUT(type: .departureAirport)

    await sut.loadNextPage()

    XCTAssertEqual(mockBookSearchService.searchBooksCallCount, 0)
  }

  /*
   특정 최근 검색어 삭제 시 recentSearches가 올바르게 업데이트되는지 검증하는 테스트
   - Given: 최근 검색어가 저장된 MockRecentSearchStorage와 type이 .book인 SearchViewModel
   - When: deleteRecentSearch(_:) 호출
   - Then: 지정한 검색어만 삭제되고 나머지는 유지되는지 확인합니다.
   */
  func test_deleteRecentSearch_removesSingleRecentSearch() {
    mockRecentSearchStorage.stubbedFetchResult[.book] = ["설국", "데미안"]
    sut = makeSUT(type: .book)

    sut.deleteRecentSearch("설국")

    XCTAssertEqual(sut.recentSearches, ["데미안"])
  }

  /*
   전체 최근 검색어 삭제 시 recentSearches가 비워지는지 검증하는 테스트
   - Given: 최근 검색어가 저장된 MockRecentSearchStorage와 type이 .book인 SearchViewModel
   - When: deleteAllRecentSearch() 호출
   - Then: recentSearches가 빈 배열이 되는지 확인합니다.
   */
  func test_deleteAllRecentSearch_clearsAllRecentSearches() {
    mockRecentSearchStorage.stubbedFetchResult[.book] = ["설국", "데미안"]
    sut = makeSUT(type: .book)

    sut.deleteAllRecentSearch()

    XCTAssertEqual(sut.recentSearches, [])
  }

  /*
   도서 상세 조회 시 서비스 결과를 그대로 반환하는지 검증하는 테스트
   - Given: 상세 도서 정보가 설정된 MockBookSearchService와 SearchViewModel
   - When: fetchBookDetail(for:) 호출
   - Then: 서비스가 반환한 BookInfo가 그대로 반환되는지 확인합니다.
   */
  func test_fetchBookDetail_returnsDetailFromService() async throws {
    sut = makeSUT(type: .book)

    let item = makeBookSearchItem(title: "설국")
    let expected = makeBookInfo(title: "설국")
    mockBookSearchService.stubbedBookDetail = expected

    let result = try await sut.fetchBookDetail(for: item)

    XCTAssertEqual(result, expected)
    XCTAssertEqual(mockBookSearchService.lastFetchDetailISBN13, item.isbn13)
  }

  /*
   도서 검색 실패 시 ViewModel이 onError 콜백을 호출하는지 검증하는 테스트
   - Given: 검색 실패를 반환하도록 설정된 MockBookSearchService와 SearchViewModel
   - When: search(query:) 호출
   - Then: onError가 호출되고 에러 메시지가 전달되는지 확인합니다.
   */
  func test_search_callsOnError_whenBookSearchFails() async {
    sut = makeSUT(type: .book)
    mockBookSearchService.stubbedSearchError = BookSearchError.invalidResponse

    let exp = expectation(description: "onError called")
    var receivedMessage: String?

    sut.onError = { message in
      receivedMessage = message
      exp.fulfill()
    }

    await sut.search(query: "실패")

    await fulfillment(of: [exp], timeout: 1.0)
    XCTAssertEqual(receivedMessage, BookSearchError.invalidResponse.errorDescription)
  }

  /*
   초기화 시 공항 데이터 preload를 위해 loadAirports가 호출되는지 검증하는 테스트
   - Given: MockAirportSearchService
   - When: SearchViewModel 초기화
   - Then: loadAirports가 1회 호출되는지 확인합니다.
   */
  func test_init_callsLoadAirports() {
    sut = makeSUT(type: .departureAirport)

    XCTAssertEqual(mockAirportSearchService.loadAirportsCallCount, 1)
  }
}

// MARK: - Helper
private extension SearchViewModelTests {
  func makeSUT(type: SearchType) -> SearchViewModel {
    SearchViewModel(
      type: type,
      bookSearchService: mockBookSearchService,
      airportSearchService: mockAirportSearchService,
      recentSearchStorage: mockRecentSearchStorage
    )
  }

  func makeBookSearchItem(title: String) -> BookSearchItem {
    BookSearchItem(
      title: title,
      author: "작가",
      coverURL: "https://example.com/cover.jpg",
      publisher: "출판사",
      isbn13: "9788937460616"
    )
  }

  func makeBookInfo(title: String) -> BookInfo {
    BookInfo(
      isbn13: "9788937460616",
      title: title,
      author: "작가",
      publisher: "출판사",
      itemPage: 176,
      cover: "https://example.com/cover.jpg"
    )
  }

  func makeAirport(iata: String, cityKo: String) -> AirportInfo {
    AirportInfo(
      iata: iata,
      airportNameEn: "Airport",
      airportNameKo: "공항",
      cityNameEn: "City",
      cityNameKo: cityKo,
      countryNameKo: "대한민국",
      latitude: 1.0,
      longitude: 1.0,
      searchText: "\(iata.lowercased()) \(cityKo)"
    )
  }
}
