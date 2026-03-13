//
//  SearchViewModel.swift
//  Search
//
//  Created by 여성일 on 3/11/26.
//

import Core
import Foundation
import SearchInterface

public final class SearchViewModel {
  private let type: SearchType
  private let bookSearchService: BookSearchServicing
  private let recentSearchStorage: RecentSearchStoring
  
  var onBooksChanged: (([BookSearchItem]) -> Void)?
  var onRecentSearchesChanged: (([String]) -> Void)?
  var onError: ((Error) -> Void)?
  
  var placeholder: String {
    switch type {
    case .book:
      return "검색어를 입력하세요"
    case .departureAirport:
      return "출발 공항 검색 (공항명/도시/코드)"
    case .arrivalAirport:
      return "도착 공항 검색 (공항명/도시/코드)"
    }
  }
  
  private(set) var books: [BookSearchItem] = [] {
    didSet { onBooksChanged?(books) }
  }
  
  private(set) var recentSearches: [String] = [] {
    didSet { onRecentSearchesChanged?(recentSearches) }
  }
  
  private var currentQuery: String = ""
  private var currentPage: Int = 1
  private var totalResult: Int = 0
  private var isLoading = false
  private var hasNextPage: Bool {
    books.count < totalResult
  } // 다음 페이지가 존재하는지 여부를 나타내는 변수
  
  public init(
    type: SearchType,
    bookSearchService: BookSearchServicing,
    recentSearchStorage: RecentSearchStoring
  ) {
    self.type = type
    self.bookSearchService = bookSearchService
    self.recentSearchStorage = recentSearchStorage
    
    recentSearches = recentSearchStorage.fetch(type: type)
  }
  
  // MARK: - Public Method
  func searchBooks(query: String) async {
    // 현재 API 요청 중이 아닐 때만(로딩 상태) 검색 요청
    guard !isLoading else { return }
    
    currentQuery = query
    currentPage = 1
    books = []
    
    recentSearchStorage.save(query, type: type)
    loadRecentSearches()
    await loadPage()
  }
  
  func loadNextPage() async {
    // 로딩 상태가 아니고, 다음 페이지가 존재하고, 검색어 쿼리가 공백이 아닐 때만 다음 페이지 요청
    guard !isLoading, hasNextPage, !currentQuery.isEmpty else { return }
    currentPage += 1
    
    await loadPage()
  }

  func deleteRecentSearch(_ query: String) {
    recentSearchStorage.delete(query, type: type)
    loadRecentSearches()
  }
  
  func deleteAllRecentSearch() {
    recentSearchStorage.deleteAll(type: type)
    recentSearches = []
  }
  
  func loadRecentSearches() {
    recentSearches = recentSearchStorage.fetch(type: type)
  }
}

// MARK: - Private
private extension SearchViewModel {
  private func loadPage() async {
    isLoading = true
    
    defer { isLoading = false } // 현재 함수가 끝나기 직전에 반드시 실행되어야 함. defer 없으면 모든 경우의 수에서 isLoading = false를 실행해야 함.
    
    do {
      let page = try await bookSearchService.searchBooks(
        query: currentQuery,
        start: currentPage,
      )
      
      totalResult = page.totalResults
      
      if currentPage == 1 {
        // 첫번째 페이지라면 item 반환
        books = page.items
      } else {
        // 다음 페이지라면 현재 아이템에 추가 검색 아이템 더해서 반환
        books.append(contentsOf: page.items)
      }
    } catch {
      if currentPage > 1 { // 첫 페이지에서 검색 실패시 롤백을 막기 위한 조건
        currentPage -= 1 // loadNextPage()에서 페이지를 먼저 증가시킴. 따라서 검색 실패 시 잘못 된 currentPage 값을 롤백하기 위한 연산
      }
      onError?(error)
    }
  }
}
