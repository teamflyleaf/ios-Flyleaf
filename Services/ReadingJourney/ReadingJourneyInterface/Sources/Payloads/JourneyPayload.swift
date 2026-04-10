//
//  JourneyPayload.swift
//  Core
//
//  Created by 여성일 on 3/19/26.
//

import Core
import Foundation

public struct JourneyPayload: Sendable, Equatable {
  public let book: BookInfo
  public let startDate: Date
  public let currentPage: Int
  public let departureAirport: AirportInfo
  public let destinationAirport: AirportInfo
  
  public init(
    book: BookInfo,
    startDate: Date,
    currentPage: Int,
    departureAirport: AirportInfo,
    destinationAirport: AirportInfo
  ) {
    self.book = book
    self.startDate = startDate
    self.currentPage = currentPage
    self.departureAirport = departureAirport
    self.destinationAirport = destinationAirport
  }
}
