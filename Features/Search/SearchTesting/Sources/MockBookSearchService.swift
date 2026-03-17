//
//  MockBookSearchService.swift
//  Search
//
//  Created by 여성일 on 3/18/26.
//

import Core
import Foundation

final class MockBookSearchService: BookSearchServicing {
  var stubbedSearchPage = BookSearchPage(
    items: [],
    totalResults: 0,
    startIndex: 1,
    itemsPerPage: 10
  )
  var stubbedSearchPages: [BookSearchPage] = []
  var stubbedSearchError: Error?

  var stubbedBookDetail = BookInfo(
    isbn13: "9788937460616",
    title: "설국",
    author: "가와바타 야스나리",
    publisher: "민음사",
    itemPage: 176,
    cover: "https://example.com/book.jpg"
  )
  var stubbedBookDetailError: Error?

  private(set) var searchBooksCallCount = 0
  private(set) var lastQuery: String?
  private(set) var lastStart: Int?
  private(set) var requestedStarts: [Int] = []
  private(set) var lastFetchDetailISBN13: String?

  func searchBooks(
    query: String,
    start: Int
  ) async throws -> BookSearchPage {
    searchBooksCallCount += 1
    lastQuery = query
    lastStart = start
    requestedStarts.append(start)

    if let stubbedSearchError {
      throw stubbedSearchError
    }

    if !stubbedSearchPages.isEmpty {
      return stubbedSearchPages.removeFirst()
    }

    return stubbedSearchPage
  }

  func fetchBookDetail(
    isbn13: String
  ) async throws -> BookInfo {
    lastFetchDetailISBN13 = isbn13

    if let stubbedBookDetailError {
      throw stubbedBookDetailError
    }

    return stubbedBookDetail
  }
}
