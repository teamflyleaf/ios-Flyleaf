//
//  BookSearchService.swift
//  BookSearchImplementation
//
//  Created by 여성일 on now.
//

import Core
import Foundation
import BookSearchInterface

/// 알라딘 Open API를 이용해 도서 검색 및 상세 조회 기능을 제공하는 서비스입니다.
///
/// 검색 API(`ItemSearch`)를 통해 도서 목록을 조회하고,
/// 상세 API(`ItemLookUp`)를 통해 선택한 도서의 상세 정보를 조회합니다.
///
/// ```swift
/// let service = BookSearchService()
/// let page = try await service.searchBooks(query: "설국", start: 1)
/// let detail = try await service.fetchBookDetail(isbn13: "9788937460616")
/// ```
public final class BookSearchService: BookSearchServicing {
  private let session: URLSession
  
  public init(
    session: URLSession = .shared
  ) {
    self.session = session
  }
  
  /// 주어진 검색어로 도서를 조회하고 페이지 단위 검색 결과를 반환합니다.
  ///
  /// - Parameters:
  ///   - query: 검색할 키워드
  ///   - start: 조회를 시작할 페이지 번호
  /// - Returns: 검색 결과 목록과 전체 개수를 포함한 페이지 정보
  ///
  /// - Throws:
  ///   - `BookSearchError.invalidURL`: 요청 URL 생성에 실패한 경우
  ///   - `BookSearchError.invalidResponse`: 응답이 HTTPURLResponse로 변환되지 않은 경우
  ///   - `BookSearchError.httpError`: 서버가 200번대가 아닌 상태 코드를 반환한 경우
  ///   - `DecodingError`: 응답 JSON을 DTO로 디코딩하지 못한 경우
  ///
  /// - Important:
  ///   - 이 메서드는 알라딘 `ItemSearch` API를 사용합니다.
  ///   - 반환되는 모델은 검색 결과 전용(`BookSearchItem`)이며,
  ///     페이지 수(`itemPage`) 같은 상세 정보는 포함되지 않을 수 있습니다.
  public func searchBooks(
    query: String,
    start: Int,
  ) async throws -> BookSearchPage {
    guard var components = URLComponents(string: "https://www.aladin.co.kr/ttb/api/ItemSearch.aspx") else {
      throw BookSearchError.invalidURL
    }
    
    components.queryItems = [
      .init(name: "ttbkey", value: APIKey.aladin),
      .init(name: "Query", value: query),
      .init(name: "QueryType", value: "Keyword"),
      .init(name: "MaxResults", value: "10"),
      .init(name: "start", value: "\(start)"),
      .init(name: "SearchTarget", value: "Book"),
      .init(name: "output", value: "js"),
      .init(name: "Version", value: "20131101"),
      .init(name: "Cover", value: "Big"),
    ]
    
    guard let url = components.url else {
      throw BookSearchError.invalidURL
    }

    let (data, response) = try await session.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw BookSearchError.invalidResponse
    }

    guard 200..<300 ~= httpResponse.statusCode else {
      throw BookSearchError.httpError(statusCode: httpResponse.statusCode)
    }

    let dto = try JSONDecoder().decode(AladinSearchResponseDTO.self, from: data)
    return dto.toModel()
  }
  
  /// ISBN13을 기준으로 도서 상세 정보를 조회합니다.
  ///
  /// - Parameter isbn13: 조회할 도서의 ISBN13 코드
  /// - Returns: 페이지 수를 포함한 도서 상세 정보
  ///
  /// - Throws:
  ///   - `BookSearchError.invalidURL`: 요청 URL 생성에 실패한 경우
  ///   - `BookSearchError.invalidResponse`: 응답이 HTTPURLResponse로 변환되지 않은 경우
  ///   - `BookSearchError.httpError`: 서버가 200번대가 아닌 상태 코드를 반환한 경우
  ///   - `BookSearchError.missingBookDetail`: 상세 정보가 비어 있는 경우
  ///   - `BookSearchError.missingItemPage`: 페이지 수(`itemPage`)를 찾을 수 없는 경우
  ///   - `DecodingError`: 응답 JSON을 DTO로 디코딩하지 못한 경우
  ///
  /// - Important:
  ///   - 이 메서드는 알라딘 `ItemLookUp` API를 사용합니다.
   public func fetchBookDetail(
     isbn13: String
   ) async throws -> BookInfo {
     guard var components = URLComponents(string: "https://www.aladin.co.kr/ttb/api/ItemLookUp.aspx") else {
       throw BookSearchError.invalidURL
     }

     components.queryItems = [
       .init(name: "ttbkey", value: APIKey.aladin),
       .init(name: "ItemIdType", value: "ISBN"),
       .init(name: "ItemId", value: isbn13),
       .init(name: "output", value: "js"),
       .init(name: "Version", value: "20131101"),
       .init(name: "OptResult", value: "ebookList,usedList,reviewList"),
       .init(name: "Cover", value: "Big")
     ]

     guard let url = components.url else {
       throw BookSearchError.invalidURL
     }

     let (data, response) = try await session.data(from: url)

     guard let httpResponse = response as? HTTPURLResponse else {
       throw BookSearchError.invalidResponse
     }

     guard 200..<300 ~= httpResponse.statusCode else {
       throw BookSearchError.httpError(statusCode: httpResponse.statusCode)
     }

     let dto = try JSONDecoder().decode(AladinBookDetailResponseDTO.self, from: data)
     return try dto.toModel()
   }
}
