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
  
  var onBooksChanged: (([BookSearchItem]) -> Void)?
  var onError: ((Error) -> Void)?
  
  public init(
    type: SearchType,
    bookSearchService: BookSearchServicing
  ) {
    self.type = type
    self.bookSearchService = bookSearchService
  }
  
  var placeholder: String {
    type.placeholder
  }
  
  private(set) var books: [BookSearchItem] = [] {
    didSet { onBooksChanged?(books) }
  }
  
  // MARK: - Public Method
  func searchBooks(query: String) async {
    do {
      let books = try await bookSearchService.searchBooks(query: query)
      self.books = books
    } catch {
      onError?(error)
    }
  }
}
