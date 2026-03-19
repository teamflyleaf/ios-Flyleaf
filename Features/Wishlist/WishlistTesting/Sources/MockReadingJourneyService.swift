//
//  MockReadingJourneyService.swift
//  Wishlist
//
//  Created by 여성일 on 3/18/26.
//

import Core
import Foundation

final class MockReadingJourneyService: ReadingJourneyServicing {
  var stubbedCreateWishlistJourneyResult: ReadingJourney?
  var stubbedCreateWishlistJourneyError: Error?

  private(set) var createWishlistJourneyCallCount = 0
  private(set) var lastPayload: WishlistTicketPayload?

  func createWishlistJourney(
    payload: WishlistTicketPayload
  ) async throws -> ReadingJourney {
    createWishlistJourneyCallCount += 1
    lastPayload = payload

    if let stubbedCreateWishlistJourneyError {
      throw stubbedCreateWishlistJourneyError
    }

    guard let stubbedCreateWishlistJourneyResult else {
      throw MockReadingJourneyError.failed
    }

    return stubbedCreateWishlistJourneyResult
  }
  
  func createHistoryJourney(payload: HistoryPayload) async throws -> ReadingJourney {
    fatalError("Not used")
  }
  
  func createJourney(payload: JourneyPayload) async throws -> ReadingJourney {
    fatalError("Not used")
  }
  
  func fetchReadingJourneys() async throws -> [ReadingJourney] {
    fatalError("Not used")
  }
}
