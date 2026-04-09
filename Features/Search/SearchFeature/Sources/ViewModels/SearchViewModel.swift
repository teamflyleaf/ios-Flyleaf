//
//  SearchViewModel.swift
//  Search
//
//  Created by 여성일 on 3/11/26.
//

import Core
import Foundation
import SearchInterface
import SearchHistoryInterface
import AirportSearchInterface

public final class SearchViewModel {
  private(set) var type: SearchType
  private let bookSearchService: BookSearchServicing
  private let airportSearchService: AirportSearchServicing
  private let searchHistoryService: SearchHistoryServicing
  
  var onBooksChanged: (([BookSearchItem]) -> Void)?
  var onAirportsChanged: (([AirportInfo]) -> Void)?
  var onRecentSearchesChanged: (([String]) -> Void)?
  var onError: ((String) -> Void)?
  
  // 검색 타입에 따른 placeholder 텍스트
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
  
  // 도서 검색 결과
  private(set) var books: [BookSearchItem] = [] {
    didSet { onBooksChanged?(books) }
  }
  
  // 공항 검색 결과
  private(set) var airports: [AirportInfo] = [] {
    didSet { onAirportsChanged?(airports) }
  }
  
  // 최근 검색어 리스트
  private(set) var recentSearches: [String] = [] {
    didSet { onRecentSearchesChanged?(recentSearches) }
  }
  
  // 현재 검색어
  private var currentQuery: String = ""
  
  // 현재 페이지 (도서 검색용)
  private var currentPage: Int = 1
  
  // 전체 검색 결과 수
  private var totalResult: Int = 0
  
  // 로딩 중 여부 (중복 요청 방지용)
  private var isLoading = false
  
  // 다음 페이지가 존재하는지 여부
  private var hasNextPage: Bool {
    books.count < totalResult
  }
  
  public init(
    type: SearchType,
    bookSearchService: BookSearchServicing,
    airportSearchService: AirportSearchServicing,
    searchHistoryService: SearchHistoryServicing
  ) {
    self.type = type
    self.bookSearchService = bookSearchService
    self.airportSearchService = airportSearchService
    self.searchHistoryService = searchHistoryService
    
    recentSearches = searchHistoryService.fetch(type: type)
    
    do {
      try airportSearchService.loadAirports()
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "공항 데이터를 불러오지 못했습니다."
      onError?(message)
    }
  }
  
  // MARK: - Public Method
  /// 검색을 수행합니다.
  ///
  /// - Parameter query: 검색어
  ///
  /// - Note:
  ///   - 기존 결과 초기화
  ///   - 최근 검색어 저장
  ///   - 타입에 따라 도서 / 공항 검색 분기
  func search(query: String) async {
    guard !isLoading else { return }
    
    currentQuery = query
    currentPage = 1
    books = []
    airports = []
    
    searchHistoryService.save(query, type: type)
    loadRecentSearches()
    
    switch type {
    case .book:
      await loadBookPage()
      
    case .departureAirport, .arrivalAirport:
      loadAirports()
    }
  }
  
  /// 다음 페이지를 로드합니다. (도서 검색 전용)
  func loadNextPage() async {
    guard type == .book else { return }
    guard !isLoading, hasNextPage, !currentQuery.isEmpty else { return }
    
    currentPage += 1
    await loadBookPage()
  }
  
  /// 특정 최근 검색어 삭제
  func deleteRecentSearch(_ query: String) {
    searchHistoryService.delete(query, type: type)
    loadRecentSearches()
  }
  
  /// 전체 최근 검색어 삭제
  func deleteAllRecentSearch() {
    searchHistoryService.deleteAll(type: type)
    recentSearches = []
  }
  
  /// 최근 검색어 로드
  func loadRecentSearches() {
    recentSearches = searchHistoryService.fetch(type: type)
  }
  
  /// 선택한 도서의 상세 정보를 조회합니다.
  ///
  /// - Parameter item: 선택된 도서
  /// - Returns: 상세 도서 정보
  func fetchBookDetail(
    for item: BookSearchItem
  ) async throws -> BookInfo {
    try await bookSearchService.fetchBookDetail(isbn13: item.isbn13)
  }
}

// MARK: - Private
private extension SearchViewModel {
  /// 도서 검색 API를 호출하여 페이지 데이터 로드
  func loadBookPage() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let page = try await bookSearchService.searchBooks(
        query: currentQuery,
        start: currentPage
      )
      
      totalResult = page.totalResults
      
      if currentPage == 1 {
        books = page.items
      } else {
        books.append(contentsOf: page.items)
      }
    } catch {
      if currentPage > 1 {
        currentPage -= 1
      }
      let message = (error as? LocalizedError)?.errorDescription ?? "오류가 발생했습니다."
      onError?(message)
    }
  }
  
  /// 공항 데이터를 로컬에서 필터링하여 검색
  func loadAirports() {
    let trimmedQuery = currentQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard !trimmedQuery.isEmpty else {
      airports = []
      return
    }
    
    airports = airportSearchService.searchAirports(query: trimmedQuery)
  }
}
