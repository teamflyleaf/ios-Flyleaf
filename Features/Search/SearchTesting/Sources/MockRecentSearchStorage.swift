//
//  MockRecentSearchStorage.swift
//  Search
//
//  Created by 여성일 on 3/18/26.
//

import Core
import Foundation

final class MockRecentSearchStorage: RecentSearchStoring {
  struct SavedQuery: Equatable {
    let query: String
    let type: SearchType
  }

  var stubbedFetchResult: [SearchType: [String]] = [:]
  private(set) var savedQueries: [SavedQuery] = []

  func save(_ query: String, type: SearchType) {
    savedQueries.append(.init(query: query, type: type))
    var current = stubbedFetchResult[type] ?? []
    current.removeAll { $0 == query }
    current.insert(query, at: 0)
    stubbedFetchResult[type] = current
  }

  func fetch(type: SearchType) -> [String] {
    stubbedFetchResult[type] ?? []
  }

  func delete(_ query: String, type: SearchType) {
    var current = stubbedFetchResult[type] ?? []
    current.removeAll { $0 == query }
    stubbedFetchResult[type] = current
  }

  func deleteAll(type: SearchType) {
    stubbedFetchResult[type] = []
  }
}
