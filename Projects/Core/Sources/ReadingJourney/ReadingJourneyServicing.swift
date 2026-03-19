//
//  ReadingJourneyServicing.swift
//  Core
//
//  Created by 여성일 on 3/17/26.
//

import Foundation

public protocol ReadingJourneyServicing {
  func createWishlistJourney(
    payload: WishlistTicketPayload
  ) async throws -> ReadingJourney
  
  func createHistoryJourney(
    payload: HistoryPayload
  ) async throws -> ReadingJourney
  
  func createJourney(
    payload: JourneyPayload
  ) async throws -> ReadingJourney
  
  func fetchReadingJourneys() async throws -> [ReadingJourney]
}
