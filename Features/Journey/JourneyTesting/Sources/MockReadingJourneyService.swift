//
//  MockReadingJourneyService.swift
//  Journey
//
//  Created by 여성일 on 3/20/26.
//

import Core
import Foundation

final class MockReadingJourneyService: ReadingJourneyServicing {
  var stubbedCreateJourneyResult: ReadingJourney?
  var stubbedCreateJourneyError: Error?

  var stubbedFetchReadingJourneysResult: [ReadingJourney] = []
  var stubbedFetchReadingJourneysError: Error?
  
  private(set) var createJourneyCallCount = 0
  private(set) var fetchReadingJourneysCallCount = 0
  private(set) var lastJourneyPayload: JourneyPayload?

  func createJourney(
    payload: JourneyPayload
  ) async throws -> ReadingJourney {
    createJourneyCallCount += 1
    lastJourneyPayload = payload

    if let stubbedCreateJourneyError {
      throw stubbedCreateJourneyError
    }

    guard let stubbedCreateJourneyResult else {
      throw MockReadingJourneyError.failed
    }

    return stubbedCreateJourneyResult
  }

  func createWishlistJourney(
    payload: WishlistTicketPayload
  ) async throws -> ReadingJourney {
    fatalError("Not used in JourneyTicketViewModelTests")
  }

  func createHistoryJourney(
    payload: HistoryPayload
  ) async throws -> ReadingJourney {
    fatalError("Not used in JourneyTicketViewModelTests")
  }

  func fetchReadingJourneys() async throws -> [ReadingJourney] {
    fetchReadingJourneysCallCount += 1
    
    if let stubbedFetchReadingJourneysError {
      throw stubbedFetchReadingJourneysError
    }
    
    return stubbedFetchReadingJourneysResult
  }
  
  func fetchWishlist() async throws -> [ReadingJourney] {
    fatalError("Not used in JourneyTicketViewModelTests")
  }
  
  func updateJourneyStatusToReading(journeyId: String, startDate: Date, currentPage: Int) async throws -> ReadingJourney {
    fatalError("Not used in JourneyTicketViewModelTests")
  }
  
  func deleteWishlistJourney(journeyId: String) async throws {
    fatalError("Not used in JourneyTicketViewModelTests")
  }
}
