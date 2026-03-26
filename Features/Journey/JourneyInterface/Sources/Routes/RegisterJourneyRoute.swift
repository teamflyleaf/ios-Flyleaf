//
//  RegisterJourneyRoute.swift
//  Journey
//
//  Created by 여성일 on 3/26/26.
//

import Core
import Foundation

public enum RegisterJourneyRoute {
  case back
  case bookSearch((BookInfo) -> Void)
  case departureSearch((AirportInfo) -> Void)
  case destinationSearch((AirportInfo) -> Void)
  case createTicket(BookInfo, AirportInfo, AirportInfo, Date, Int)
}
