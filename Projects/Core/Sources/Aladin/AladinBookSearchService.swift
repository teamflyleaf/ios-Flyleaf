//
//  AladinBookSearchService.swift
//  Core
//
//  Created by 여성일 on 3/12/26.
//

import Foundation

public final class AladinBookSearchService: BookSearchServicing {
  private let session: URLSession
  
  public init(
    session: URLSession = .shared
  ) {
    self.session = session
  }
  
  public func searchBooks(query: String) async throws -> [BookSearchItem] {
    guard var components = URLComponents(string: "https://www.aladin.co.kr/ttb/api/ItemSearch.aspx") else {
      throw BookSearchError.invalidURL
    }
    
    components.queryItems = [
      .init(name: "ttbkey", value: APIKey.aladin),
      .init(name: "Query", value: query),
      .init(name: "QueryType", value: "Keyword"),
      .init(name: "MaxResults", value: "10"),
      .init(name: "start", value: "1"),
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
    
    let decoder = JSONDecoder()
    let dto = try decoder.decode(AladinSearchResponseDTO.self, from: data)
    
    return dto.item.map { $0.toModel() }
  }
}
