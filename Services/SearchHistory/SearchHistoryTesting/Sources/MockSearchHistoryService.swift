//
//  MockSearchHistoryService.swift
//  SearchHistoryTesting
//
//  Created by 여성일 on now.
//

import Core
import Foundation
import SearchHistoryInterface

public final class MockSearchHistoryService: SearchHistoryServicing {
  public init() {}
  
  public func fetch(type: SearchType) -> [String] {
    fatalError()
  }
  
  public func save(_ query: String, type: SearchType) {
    fatalError()
  }
  
  public func delete(_ query: String, type: SearchType) {
    fatalError()
  }
  
  public func deleteAll(type: SearchType) {
    fatalError()
  }
}
