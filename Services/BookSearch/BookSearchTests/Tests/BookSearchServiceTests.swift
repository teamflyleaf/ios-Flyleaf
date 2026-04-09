//
//  BookSearchServiceTests.swift
//  BookSearchTests
//
//  Created by 여성일 on now.
//

import XCTest
@testable import BookSearchImplementation
import BookSearchInterface
import BookSearchTesting
import Core

final class BookSearchServiceTests: XCTestCase {
  private var session: URLSession!
  private var sut: BookSearchService!
  
  override func setUp() {
    super.setUp()
    
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    session = URLSession(configuration: configuration)
    sut = BookSearchService(
      session: session,
      apiKey: "test-api-key"
    )
  }
  
  override func tearDown() {
    MockURLProtocol.requestHandler = nil
    session = nil
    sut = nil
    super.tearDown()
  }
  
  /*
   도서 검색 요청이 성공했을 때 검색 결과를 정상적으로 반환하는지 검증하는 테스트
   - Given: 정상적인 검색 응답 JSON을 반환하는 MockURLProtocol
   - When: searchBooks 호출
   - Then:
   - 알라딘 검색 API 경로와 쿼리 파라미터가 올바르게 구성되는지
   - 검색 결과가 정상적으로 디코딩되어 반환되는지 확인합니다.
   */
  func test_searchBooks_success_returnsDecodedPage() async throws {
    let json = """
    {
      "version": "20131101",
      "title": "알라딘 검색결과",
      "pubDate": "2026-03-12",
      "totalResults": 1,
      "startIndex": 1,
      "itemsPerPage": 10,
      "query": "설국",
      "searchCategoryId": 0,
      "searchCategoryName": "국내도서",
      "item": [
        {
          "title": "설국",
          "link": "https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=1",
          "author": "가와바타 야스나리",
          "pubDate": "2009-01-01",
          "description": "설국 설명",
          "isbn": "8937460611",
          "isbn13": "9788937460616",
          "itemId": 1,
          "priceSales": 11700,
          "priceStandard": 13000,
          "mallType": "BOOK",
          "stockStatus": "",
          "mileage": 650,
          "cover": "https://image.aladin.co.kr/product/1/cover.jpg",
          "categoryId": 123,
          "categoryName": "소설/시/희곡",
          "publisher": "민음사",
          "salesPoint": 1000,
          "adult": false,
          "fixedPrice": true,
          "customerReviewRank": 8
        }
      ]
    }
    """
    
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      XCTAssertEqual(url.host, "www.aladin.co.kr")
      XCTAssertEqual(url.path, "/ttb/api/ItemSearch.aspx")
      
      let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
      let queryItems = components.queryItems ?? []
      
      XCTAssertEqual(queryItems.first(where: { $0.name == "Query" })?.value, "설국")
      XCTAssertEqual(queryItems.first(where: { $0.name == "start" })?.value, "1")
      XCTAssertEqual(queryItems.first(where: { $0.name == "QueryType" })?.value, "Keyword")
      XCTAssertEqual(queryItems.first(where: { $0.name == "SearchTarget" })?.value, "Book")
      
      let response = HTTPURLResponse(
        url: url,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )
      
      return (response, Data(json.utf8))
    }
    
    let result = try await sut.searchBooks(query: "설국", start: 1)
    
    XCTAssertEqual(result.totalResults, 1)
    XCTAssertEqual(result.items.count, 1)
    XCTAssertEqual(result.items.first?.title, "설국")
    XCTAssertEqual(result.items.first?.author, "가와바타 야스나리")
    XCTAssertEqual(result.items.first?.publisher, "민음사")
    XCTAssertEqual(result.items.first?.isbn13, "9788937460616")
  }
  
  /*
   도서 검색 응답 상태 코드가 200번대가 아닐 때 httpError를 던지는지 검증하는 테스트
   - Given: 500 상태 코드를 반환하는 MockURLProtocol
   - When: searchBooks 호출
   - Then: BookSearchError.httpError를 던지고 상태 코드를 포함하는지 확인합니다.
   */
  func test_searchBooks_throwsHttpError_whenStatusCodeIsNot2xx() async {
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      let response = HTTPURLResponse(
        url: url,
        statusCode: 500,
        httpVersion: nil,
        headerFields: nil
      )
      return (response, Data())
    }
    
    do {
      _ = try await sut.searchBooks(query: "설국", start: 1)
      XCTFail("Expected httpError to be thrown")
    } catch let error as BookSearchError {
      guard case .httpError(let statusCode) = error else {
        return XCTFail("Expected httpError, got \(error)")
      }
      XCTAssertEqual(statusCode, 500)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  /*
   도서 검색 응답이 HTTPURLResponse가 아닐 때 invalidResponse를 던지는지 검증하는 테스트
   - Given: HTTPURLResponse 없이 데이터만 반환하는 MockURLProtocol
   - When: searchBooks 호출
   - Then: BookSearchError.invalidResponse를 던지는지 확인합니다.
   */
  func test_searchBooks_throwsInvalidResponse_whenResponseIsNotHTTPURLResponse() async {
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      let response = URLResponse(
        url: url,
        mimeType: "application/json",
        expectedContentLength: 0,
        textEncodingName: nil
      )
      return (response, Data("{}".utf8))
    }
    
    do {
      _ = try await sut.searchBooks(query: "설국", start: 1)
      XCTFail("Expected invalidResponse to be thrown")
    } catch let error as BookSearchError {
      XCTAssertEqual(
        error.errorDescription,
        BookSearchError.invalidResponse.errorDescription
      )
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  /*
   도서 검색 응답 JSON 형식이 올바르지 않을 때 디코딩 에러를 던지는지 검증하는 테스트
   - Given: DTO 형식과 맞지 않는 잘못된 JSON을 반환하는 MockURLProtocol
   - When: searchBooks 호출
   - Then: DecodingError를 던지는지 확인합니다.
   */
  func test_searchBooks_throwsDecodingError_whenJSONIsInvalid() async {
    let invalidJSON = """
    {
      "unexpected_key": "unexpected_value"
    }
    """
    
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      let response = HTTPURLResponse(
        url: url,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )
      return (response, Data(invalidJSON.utf8))
    }
    
    do {
      _ = try await sut.searchBooks(query: "설국", start: 1)
      XCTFail("Expected decoding error to be thrown")
    } catch is DecodingError {
      XCTAssertTrue(true)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  /*
   도서 상세 조회 요청이 성공했을 때 상세 정보를 정상적으로 반환하는지 검증하는 테스트
   - Given: 정상적인 도서 상세 응답 JSON을 반환하는 MockURLProtocol
   - When: fetchBookDetail 호출
   - Then:
   - 알라딘 상세 조회 API 경로와 쿼리 파라미터가 올바르게 구성되는지
   - 상세 정보가 정상적으로 디코딩되어 반환되는지 확인합니다.
   */
  func test_fetchBookDetail_success_returnsDecodedBookInfo() async throws {
    let json = """
    {
      "version": "20131101",
      "title": "알라딘 상품정보",
      "link": "https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=1",
      "pubDate": "2026-03-12",
      "totalResults": 1,
      "item": [
        {
          "title": "설국",
          "link": "https://www.aladin.co.kr/shop/wproduct.aspx?ItemId=1",
          "author": "가와바타 야스나리",
          "description": "설국 설명",
          "isbn": "8937460611",
          "isbn13": "9788937460616",
          "itemId": 1,
          "priceSales": 11700,
          "priceStandard": 13000,
          "mallType": "BOOK",
          "stockStatus": "",
          "mileage": 650,
          "cover": "https://image.aladin.co.kr/product/1/cover.jpg",
          "categoryId": 123,
          "categoryName": "소설/시/희곡",
          "publisher": "민음사",
          "salesPoint": 1000,
          "adult": false,
          "fixedPrice": true,
          "customerReviewRank": 8,
          "subInfo": {
            "itemPage": 200
          }
        }
      ]
    }
    """
    
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      XCTAssertEqual(url.host, "www.aladin.co.kr")
      XCTAssertEqual(url.path, "/ttb/api/ItemLookUp.aspx")
      
      let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
      let queryItems = components.queryItems ?? []
      
      XCTAssertEqual(queryItems.first(where: { $0.name == "ItemIdType" })?.value, "ISBN")
      XCTAssertEqual(queryItems.first(where: { $0.name == "ItemId" })?.value, "9788937460616")
      XCTAssertEqual(queryItems.first(where: { $0.name == "output" })?.value, "js")
      
      let response = HTTPURLResponse(
        url: url,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )
      
      return (response, Data(json.utf8))
    }
    
    let result = try await sut.fetchBookDetail(isbn13: "9788937460616")
    
    XCTAssertEqual(result.title, "설국")
    XCTAssertEqual(result.author, "가와바타 야스나리")
    XCTAssertEqual(result.publisher, "민음사")
    XCTAssertEqual(result.isbn13, "9788937460616")
    XCTAssertEqual(result.itemPage, 200)
  }
  
  /*
   도서 상세 조회 응답 상태 코드가 200번대가 아닐 때 httpError를 던지는지 검증하는 테스트
   - Given: 404 상태 코드를 반환하는 MockURLProtocol
   - When: fetchBookDetail 호출
   - Then: BookSearchError.httpError를 던지고 상태 코드를 포함하는지 확인합니다.
   */
  func test_fetchBookDetail_throwsHttpError_whenStatusCodeIsNot2xx() async {
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      let response = HTTPURLResponse(
        url: url,
        statusCode: 404,
        httpVersion: nil,
        headerFields: nil
      )
      return (response, Data())
    }
    
    do {
      _ = try await sut.fetchBookDetail(isbn13: "9788937460616")
      XCTFail("Expected httpError to be thrown")
    } catch let error as BookSearchError {
      guard case .httpError(let statusCode) = error else {
        return XCTFail("Expected httpError, got \(error)")
      }
      XCTAssertEqual(statusCode, 404)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  /*
   도서 상세 조회 응답이 HTTPURLResponse가 아닐 때 invalidResponse를 던지는지 검증하는 테스트
   - Given: URLResponse를 반환하는 MockURLProtocol
   - When: fetchBookDetail 호출
   - Then: BookSearchError.invalidResponse를 던지는지 확인합니다.
   */
  func test_fetchBookDetail_throwsInvalidResponse_whenResponseIsNotHTTPURLResponse() async {
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      let response = URLResponse(
        url: url,
        mimeType: "application/json",
        expectedContentLength: 0,
        textEncodingName: nil
      )
      return (response, Data("{}".utf8))
    }
    
    do {
      _ = try await sut.fetchBookDetail(isbn13: "9788937460616")
      XCTFail("Expected invalidResponse to be thrown")
    } catch let error as BookSearchError {
      XCTAssertEqual(
        error.errorDescription,
        BookSearchError.invalidResponse.errorDescription
      )
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  /*
   도서 상세 조회 응답 JSON 형식이 올바르지 않을 때 디코딩 에러를 던지는지 검증하는 테스트
   - Given: DTO 형식과 맞지 않는 잘못된 JSON을 반환하는 MockURLProtocol
   - When: fetchBookDetail 호출
   - Then: DecodingError를 던지는지 확인합니다.
   */
  func test_fetchBookDetail_throwsDecodingError_whenJSONIsInvalid() async {
    let invalidJSON = """
    {
      "unexpected_key": "unexpected_value"
    }
    """
    
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      let response = HTTPURLResponse(
        url: url,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )
      return (response, Data(invalidJSON.utf8))
    }
    
    do {
      _ = try await sut.fetchBookDetail(isbn13: "9788937460616")
      XCTFail("Expected decoding error to be thrown")
    } catch is DecodingError {
      XCTAssertTrue(true)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}
