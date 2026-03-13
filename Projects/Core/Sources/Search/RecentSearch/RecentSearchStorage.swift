//
//  RecentSearchStorage.swift
//  Core
//
//  Created by 여성일 on 3/13/26.
//

import Foundation

public final class RecentSearchStorage: RecentSearchStoring {
  private let userDefaults: UserDefaults
  private let maxCount: Int

  public init(
    userDefaults: UserDefaults = .standard,
    maxCount: Int = 10
  ) {
    self.userDefaults = userDefaults
    self.maxCount = maxCount
  }

  public func fetch(type: SearchType) -> [String] {
    userDefaults.stringArray(forKey: type.recentSearchKey) ?? []
  }

  public func save(_ query: String, type: SearchType) {
    let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedQuery.isEmpty else { return }

    var items = fetch(type: type)

    items.removeAll { $0 == trimmedQuery }
    items.insert(trimmedQuery, at: 0)

    if items.count > maxCount {
      items = Array(items.prefix(maxCount))
    }

    userDefaults.set(items, forKey: type.recentSearchKey)
  }

  public func delete(_ query: String, type: SearchType) {
    var items = fetch(type: type)
    items.removeAll { $0 == query }
    userDefaults.set(items, forKey: type.recentSearchKey)
  }

  public func deleteAll(type: SearchType) {
    userDefaults.removeObject(forKey: type.recentSearchKey)
  }
}
