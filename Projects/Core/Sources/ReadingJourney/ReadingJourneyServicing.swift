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
  
  func finishJourney(
    journeyId: String,
    review: String
  ) async throws -> ReadingJourney
  
  func updateJourneyCurrentPage(
    journeyId: String,
    currentPage: Int
  ) async throws -> ReadingJourney
  
  func fetchReadingJourneys() async throws -> [ReadingJourney]
  
  func fetchFinishedJourneys() async throws -> [ReadingJourney]
  
  func fetchWishlist() async throws -> [ReadingJourney]
  
  func updateJourneyStatusToReading(
    journeyId: String,
    startDate: Date,
    currentPage: Int
  ) async throws -> ReadingJourney
  
  func deleteReadingJourney(
    journeyId: String
  ) async throws
  
  func deleteWishlistJourney(
    journeyId: String
  ) async throws
  
  func deleteFinishedJourney(
    journeyId: String
  ) async throws
}
