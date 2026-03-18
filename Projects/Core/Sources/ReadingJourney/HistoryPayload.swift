//
//  HistoryPayload.swift
//  Core
//
//  Created by 여성일 on 3/18/26.
//

import Foundation

public struct HistoryPayload: Sendable, Equatable {
  public let book: BookInfo
    public let startDate: Date
    public let finishDate: Date
    public let review: String
    public let departureAirport: AirportInfo
    public let destinationAirport: AirportInfo

    public init(
      book: BookInfo,
      startDate: Date,
      finishDate: Date,
      review: String,
      departureAirport: AirportInfo,
      destinationAirport: AirportInfo
    ) {
      self.book = book
      self.startDate = startDate
      self.finishDate = finishDate
      self.review = review
      self.departureAirport = departureAirport
      self.destinationAirport = destinationAirport
    }
}
