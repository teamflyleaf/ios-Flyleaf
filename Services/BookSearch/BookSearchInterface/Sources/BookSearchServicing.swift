//
//  BookSearchServicing.swift
//  BookSearchInterface
//
//  Created by 여성일 on now.
//

import Core
import Foundation

public protocol BookSearchServicing {
  func searchBooks(
    query: String,
    start: Int
  ) async throws -> BookSearchPage

  func fetchBookDetail(
    isbn13: String
  ) async throws -> BookInfo
}
