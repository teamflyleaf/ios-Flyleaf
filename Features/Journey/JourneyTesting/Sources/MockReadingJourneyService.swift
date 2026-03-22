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
  
  var stubbedUpdateJourneyCurrentPageResult: ReadingJourney?
  var stubbedUpdateJourneyCurrentPageError: Error?
  
  var stubbedFinishJourneyResult: ReadingJourney?
  var stubbedFinishJourneyError: Error?
  
  private(set) var createJourneyCallCount = 0
  private(set) var fetchReadingJourneysCallCount = 0
  private(set) var updateJourneyCurrentPageCallCount = 0
  private(set) var finishJourneyCallCount = 0
  
  private(set) var lastJourneyPayload: JourneyPayload?
  private(set) var lastUpdateJourneyId: String?
  private(set) var lastUpdatedCurrentPage: Int?
  private(set) var lastFinishedJourneyId: String?
  private(set) var lastReview: String?

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
  
  func updateJourneyCurrentPage(
    journeyId: String,
    currentPage: Int
  ) async throws -> ReadingJourney {
    updateJourneyCurrentPageCallCount += 1
    lastUpdateJourneyId = journeyId
    lastUpdatedCurrentPage = currentPage
    
    if let stubbedUpdateJourneyCurrentPageError {
      throw stubbedUpdateJourneyCurrentPageError
    }
    
    guard let stubbedUpdateJourneyCurrentPageResult else {
      throw MockReadingJourneyError.failed
    }
    
    return stubbedUpdateJourneyCurrentPageResult
  }
  
  func finishJourney(
    journeyId: String,
    review: String
  ) async throws -> ReadingJourney {
    finishJourneyCallCount += 1
    lastFinishedJourneyId = journeyId
    lastReview = review
    
    if let stubbedFinishJourneyError {
      throw stubbedFinishJourneyError
    }
    
    guard let stubbedFinishJourneyResult else {
      throw MockReadingJourneyError.failed
    }
    
    return stubbedFinishJourneyResult
  }
  
  func fetchWishlist() async throws -> [ReadingJourney] {
    fatalError("Not used in JourneyTicketViewModelTests")
  }
  
  func updateJourneyStatusToReading(
    journeyId: String,
    startDate: Date,
    currentPage: Int
  ) async throws -> ReadingJourney {
    fatalError("Not used in JourneyTicketViewModelTests")
  }
  
  func deleteWishlistJourney(journeyId: String) async throws {
    fatalError("Not used in JourneyTicketViewModelTests")
  }
}
