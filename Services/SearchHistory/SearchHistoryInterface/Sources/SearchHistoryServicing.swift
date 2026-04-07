//
//  SearchHistoryServicing.swift
//  SearchHistoryInterface
//
//  Created by 여성일 on now.
//

import Core
import Foundation

public protocol SearchHistoryServicing {
  func fetch(type: SearchType) -> [String]
  func save(_ query: String, type: SearchType)
  func delete(_ query: String, type: SearchType)
  func deleteAll(type: SearchType)
}
