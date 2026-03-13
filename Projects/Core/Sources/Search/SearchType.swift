//
//  SearchType.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

public enum SearchType {
  case book
  case departureAirport
  case arrivalAirport

  public var recentSearchKey: String {
    switch self {
    case .book:
      return "recent_search_book"
    case .departureAirport:
      return "recent_search_departure_airport"
    case .arrivalAirport:
      return "recent_search_arrival_airport"
    }
  }
}
