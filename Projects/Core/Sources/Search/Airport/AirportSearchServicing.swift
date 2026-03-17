//
//  AirportSearchServicing.swift
//  Core
//
//  Created by 여성일 on 3/15/26.
//

import Foundation

public protocol AirportSearchServicing {
  func loadAirports() throws
  func searchAirports(query: String) -> [AirportInfo]
}
