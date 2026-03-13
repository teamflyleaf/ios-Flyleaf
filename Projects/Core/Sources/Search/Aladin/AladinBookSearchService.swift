//
//  AladinBookSearchService.swift
//  Core
//
//  Created by 여성일 on 3/12/26.
//

import Foundation

/// 알라딘 Open API를 통해 도서 검색 기능을 제공하는 서비스
public final class AladinBookSearchService: BookSearchServicing {
  private let session: URLSession
  
  public init(
    session: URLSession = .shared
  ) {
    self.session = session
  }
  
  /// 주어진 검색어로 도서를 조회하고 페이지 단위 검색 결과를 반환합니다.
  /// - Parameters:
  ///   - query: 검색할 키워드
  ///   - start: 조회를 시작할 페이지 번호
  /// - Returns: 검색 결과 목록과 전체 개수를 포함한 페이지 정보
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
      .init(name: "Version", value: "20131101")
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
}
