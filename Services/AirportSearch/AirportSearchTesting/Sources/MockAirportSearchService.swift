//
//  MockAirportSearchService.swift
//  AirportSearchTesting
//
//  Created by 여성일 on now.
//

import Core
import Foundation
import AirportSearchInterface

public final class MockAirportSearchService: AirportSearchServicing {
  public init() {}
  
  public func loadAirports() throws {
    fatalError()
  }
  
  public func searchAirports(query: String) -> [AirportInfo] {
    fatalError()
  }
}
