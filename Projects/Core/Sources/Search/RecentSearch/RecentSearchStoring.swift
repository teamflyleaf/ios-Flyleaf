//
//  RecentSearchStoring.swift
//  Core
//
//  Created by 여성일 on 3/13/26.
//

import Foundation

public protocol RecentSearchStoring {
  func fetch(type: SearchType) -> [String]
  func save(_ query: String, type: SearchType)
  func delete(_ query: String, type: SearchType)
  func deleteAll(type: SearchType)
}
