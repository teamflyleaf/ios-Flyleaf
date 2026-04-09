//
//  AirportSearchServicing.swift
//  AirportSearchInterface
//
//  Created by 여성일 on now.
//

import Core
import Foundation

public protocol AirportSearchServicing {
  func loadAirports() throws
  func searchAirports(query: String) -> [AirportInfo]
}
