//
//  WishlistTicektPayload.swift
//  Core
//
//  Created by 여성일 on 3/17/26.
//

import Foundation

public struct WishlistTicketPayload: Sendable {
  public let book: BookInfo
  public let departure: AirportInfo
  public let destination: AirportInfo
  public let reason: String

  public init(
    book: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    reason: String
  ) {
    self.book = book
    self.departure = departure
    self.destination = destination
    self.reason = reason
  }
}
