//
//  BookSearchServicing.swift
//  Core
//
//  Created by 여성일 on 3/12/26.
//

import Foundation

public protocol BookSearchServicing {
  func searchBooks(query: String) async throws -> [BookSearchItem]
}
