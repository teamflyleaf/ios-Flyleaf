//
//  BookSearchPage.swift
//  Core
//
//  Created by 여성일 on 3/13/26.
//

public struct BookSearchPage: Equatable, Sendable {
  public let items: [BookSearchItem]
  public let totalResults: Int
  public let startIndex: Int
  public let itemsPerPage: Int
  
  public init(
    items: [BookSearchItem],
    totalResults: Int,
    startIndex: Int,
    itemsPerPage: Int
  ) {
    self.items = items
    self.totalResults = totalResults
    self.startIndex = startIndex
    self.itemsPerPage = itemsPerPage
  }
}
