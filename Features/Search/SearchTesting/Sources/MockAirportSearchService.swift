//
//  MockAirportSearchService.swift
//  Search
//
//  Created by 여성일 on 3/18/26.
//

import Core
import Foundation

final class MockAirportSearchService: AirportSearchServicing {
  var stubbedSearchAirports: [AirportInfo] = []
  var stubbedLoadAirportsError: Error?

  private(set) var loadAirportsCallCount = 0
  private(set) var searchAirportsCallCount = 0
  private(set) var lastQuery: String?

  func loadAirports() throws {
    loadAirportsCallCount += 1

    if let stubbedLoadAirportsError {
      throw stubbedLoadAirportsError
    }
  }

  func searchAirports(query: String) -> [AirportInfo] {
    searchAirportsCallCount += 1
    lastQuery = query
    return stubbedSearchAirports
  }
}
