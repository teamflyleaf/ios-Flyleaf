//
//  MockBookSearchService.swift
//  BookSearchTesting
//
//  Created by 여성일 on now.
//

import BookSearchInterface
import Core
import Foundation

public final class MockBookSearchService: BookSearchServicing {
  public init() {}
  
  public private(set) var searchBooksCallCount = 0
  public private(set) var fetchBookDetailCallCount = 0
  
  public private(set) var receivedSearchQuery: String?
  public private(set) var receivedSearchStart: Int?
  public private(set) var receivedISBN13: String?
  
  public var searchBooksResult: Result<BookSearchPage, Error>?
  public var fetchBookDetailResult: Result<BookInfo, Error>?
  
  public func searchBooks(
    query: String,
    start: Int
  ) async throws -> BookSearchPage {
    searchBooksCallCount += 1
    receivedSearchQuery = query
    receivedSearchStart = start
    
    guard let result = searchBooksResult else {
      fatalError("searchBooksResult가 설정되지 않았습니다.")
    }
    
    return try result.get()
  }
  
  public func fetchBookDetail(
    isbn13: String
  ) async throws -> BookInfo {
    fetchBookDetailCallCount += 1
    receivedISBN13 = isbn13
    
    guard let result = fetchBookDetailResult else {
      fatalError("fetchBookDetailResult가 설정되지 않았습니다.")
    }
    
    return try result.get()
  }
}
