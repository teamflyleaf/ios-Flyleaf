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
   - YES24 검색 API 경로, 쿼리 파라미터, API 키 헤더가 올바르게 구성되는지
   - 검색 결과가 정상적으로 디코딩되어 반환되는지 확인합니다.
   */
  func test_searchBooks_success_returnsDecodedPage() async throws {
    let json = """
    {
      "success": true,
      "message": "성공",
      "errorCode": null,
      "data": {
        "meta": {
          "apiTitle": "상품 검색",
          "version": "v1"
        },
        "items": [
          {
            "sortOrder": 1,
            "itemId": 1,
            "title": "설국",
            "author": "가와바타 야스나리",
            "goodsType": "국내도서",
            "publisher": "민음사",
            "isbn10": "8937460611",
            "isbn13": "9788937460616",
            "shopPrice": 13000,
            "salePrice": 11700,
            "publishDate": "2009-01-01",
            "cover": "https://image.yes24.com/goods/1/L",
            "link": "https://www.yes24.com/product/goods/1",
            "contentDetail": {
              "bookIntroduction": "설국 설명",
              "bookSummary": null,
              "tableOfContents": null
            }
          }
        ],
        "currentPage": 1,
        "pageSize": 10,
        "totalCount": 1
      }
    }
    """
    
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      XCTAssertEqual(url.host, "apis.yes24.com")
      XCTAssertEqual(url.path, "/v1/goods/itemList")
      XCTAssertEqual(request.value(forHTTPHeaderField: "X-Api-Key"), "test-api-key")
      
      let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
      let queryItems = components.queryItems ?? []
      
      XCTAssertEqual(queryItems.first(where: { $0.name == "query" })?.value, "설국")
      XCTAssertEqual(queryItems.first(where: { $0.name == "page" })?.value, "1")
      XCTAssertEqual(queryItems.first(where: { $0.name == "pageSize" })?.value, "10")
      XCTAssertEqual(queryItems.first(where: { $0.name == "category" })?.value, "BOOK")
      
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
    XCTAssertEqual(result.startIndex, 1)
    XCTAssertEqual(result.itemsPerPage, 10)
    XCTAssertEqual(result.items.count, 1)
    XCTAssertEqual(result.items.first?.title, "설국")
    XCTAssertEqual(result.items.first?.author, "가와바타 야스나리")
    XCTAssertEqual(result.items.first?.publisher, "민음사")
    XCTAssertEqual(result.items.first?.isbn13, "9788937460616")
    XCTAssertEqual(result.items.first?.coverURL, "https://image.yes24.com/goods/1/L")
  }
  
  /*
   검색 결과가 없을 때 빈 페이지를 반환하는지 검증하는 테스트
   - Given: 404 상태 코드와 SEARCH_001 에러 코드를 반환하는 MockURLProtocol
   - When: searchBooks 호출
   - Then: 에러를 던지지 않고 빈 검색 결과 페이지를 반환하는지 확인합니다.
   */
  func test_searchBooks_returnsEmptyPage_whenErrorCodeIsSearch001() async throws {
    let json = """
    {
      "success": false,
      "message": "검색 결과가 없습니다.",
      "errorCode": "SEARCH_001"
    }
    """
    
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      let response = HTTPURLResponse(
        url: url,
        statusCode: 404,
        httpVersion: nil,
        headerFields: nil
      )
      return (response, Data(json.utf8))
    }
    
    let result = try await sut.searchBooks(query: "없는검색어", start: 1)
    
    XCTAssertEqual(result.totalResults, 0)
    XCTAssertTrue(result.items.isEmpty)
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
   - YES24 상세 조회 API 경로, 쿼리 파라미터, API 키 헤더가 올바르게 구성되는지
   - 상세 정보가 정상적으로 디코딩되어 반환되는지 확인합니다.
   */
  func test_fetchBookDetail_success_returnsDecodedBookInfo() async throws {
    let json = """
    {
      "success": true,
      "message": "성공",
      "errorCode": null,
      "data": {
        "meta": {
          "apiTitle": "상품 상세 조회",
          "version": "v1"
        },
        "items": [
          {
            "sortOrder": 1,
            "itemId": 1,
            "title": "설국",
            "subTitle": "",
            "author": "가와바타 야스나리",
            "goodsType": "국내도서",
            "publisher": "민음사",
            "isbn10": "8937460611",
            "isbn13": "9788937460616",
            "shopPrice": 13000,
            "salePrice": 11700,
            "publishDate": "2009-01-01",
            "pages": 200,
            "cover": "https://image.yes24.com/goods/1/L",
            "link": "https://www.yes24.com/product/goods/1",
            "contentDetail": {
              "bookIntroduction": "설국 설명",
              "bookSummary": null,
              "tableOfContents": null
            },
            "series": []
          }
        ],
        "currentPage": 1,
        "pageSize": 1,
        "totalCount": 1
      }
    }
    """
    
    MockURLProtocol.requestHandler = { request in
      let url = try XCTUnwrap(request.url)
      XCTAssertEqual(url.host, "apis.yes24.com")
      XCTAssertEqual(url.path, "/v1/goods/itemDetail")
      XCTAssertEqual(request.value(forHTTPHeaderField: "X-Api-Key"), "test-api-key")
      
      let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
      let queryItems = components.queryItems ?? []
      
      XCTAssertEqual(queryItems.first(where: { $0.name == "searchType" })?.value, "ISBN13")
      XCTAssertEqual(queryItems.first(where: { $0.name == "query" })?.value, "9788937460616")
      XCTAssertEqual(queryItems.first(where: { $0.name == "detail" })?.value, "Y")
      
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
    XCTAssertEqual(result.cover, "https://image.yes24.com/goods/1/L")
    XCTAssertEqual(result.description, "설국 설명")
  }
  
  /*
   페이지 수가 없을 때 missingItemPage를 던지는지 검증하는 테스트
   - Given: pages가 null인 도서 상세 응답 JSON을 반환하는 MockURLProtocol
   - When: fetchBookDetail 호출
   - Then: BookSearchError.missingItemPage를 던지는지 확인합니다.
   */
  func test_fetchBookDetail_throwsMissingItemPage_whenPagesIsNull() async {
    let json = """
    {
      "success": true,
      "data": {
        "items": [
          {
            "title": "설국",
            "author": "가와바타 야스나리",
            "publisher": "민음사",
            "isbn13": "9788937460616",
            "pages": null,
            "cover": "https://image.yes24.com/goods/1/L",
            "contentDetail": null
          }
        ]
      }
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
      return (response, Data(json.utf8))
    }
    
    do {
      _ = try await sut.fetchBookDetail(isbn13: "9788937460616")
      XCTFail("Expected missingItemPage to be thrown")
    } catch let error as BookSearchError {
      guard case .missingItemPage = error else {
        return XCTFail("Expected missingItemPage, got \(error)")
      }
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
  
  /*
   책 소개가 없을 때 description을 빈 문자열로 반환하는지 검증하는 테스트
   - Given: contentDetail이 null인 도서 상세 응답 JSON을 반환하는 MockURLProtocol
   - When: fetchBookDetail 호출
   - Then: 에러 없이 description이 빈 문자열인 BookInfo를 반환하는지 확인합니다.
   */
  func test_fetchBookDetail_returnsEmptyDescription_whenContentDetailIsNull() async throws {
    let json = """
    {
      "success": true,
      "data": {
        "items": [
          {
            "title": "설국",
            "author": "가와바타 야스나리",
            "publisher": "민음사",
            "isbn13": "9788937460616",
            "pages": 200,
            "cover": "https://image.yes24.com/goods/1/L",
            "contentDetail": null
          }
        ]
      }
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
      return (response, Data(json.utf8))
    }
    
    let result = try await sut.fetchBookDetail(isbn13: "9788937460616")
    
    XCTAssertEqual(result.description, "")
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
