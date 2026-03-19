//
//  MockReadingJourenyService.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import Foundation

final class MockReadingJourneyService: ReadingJourneyServicing {
  var stubbedCreateWishlistJourneyResult: ReadingJourney?
  var stubbedCreateWishlistJourneyError: Error?

  var stubbedCreateHistoryJourneyResult: ReadingJourney?
  var stubbedCreateHistoryJourneyError: Error?

  private(set) var createWishlistJourneyCallCount = 0
  private(set) var createHistoryJourneyCallCount = 0

  func createWishlistJourney(
    payload: WishlistTicketPayload
  ) async throws -> ReadingJourney {
    createWishlistJourneyCallCount += 1

    if let stubbedCreateWishlistJourneyError {
      throw stubbedCreateWishlistJourneyError
    }

    guard let stubbedCreateWishlistJourneyResult else {
      throw MockReadingJourneyError.failed
    }

    return stubbedCreateWishlistJourneyResult
  }

  func createHistoryJourney(
    payload: HistoryPayload
  ) async throws -> ReadingJourney {
    createHistoryJourneyCallCount += 1

    if let stubbedCreateHistoryJourneyError {
      throw stubbedCreateHistoryJourneyError
    }

    guard let stubbedCreateHistoryJourneyResult else {
      throw MockReadingJourneyError.failed
    }

    return stubbedCreateHistoryJourneyResult
  }
  
  func createJourney(payload: JourneyPayload) async throws -> ReadingJourney {
    fatalError("Not used")
  }
  
  func fetchReadingJourneys() async throws -> [ReadingJourney] {
    fatalError("Not used")
  }
}
