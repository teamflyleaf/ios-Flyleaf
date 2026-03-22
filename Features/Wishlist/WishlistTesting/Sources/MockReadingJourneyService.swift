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
  
  var stubbedCreateHistoryJourneyResult: ReadingJourney?
  var stubbedCreateHistoryJourneyError: Error?
  
  var stubbedCreateJourneyResult: ReadingJourney?
  var stubbedCreateJourneyError: Error?
  
  var stubbedFetchReadingJourneysResult: [ReadingJourney] = []
  var stubbedFetchReadingJourneysError: Error?
  
  var stubbedFetchWishlistResult: [ReadingJourney] = []
  var stubbedFetchWishlistError: Error?
  
  var stubbedUpdatedJourneyResult: ReadingJourney?
  var stubbedUpdateJourneyStatusToReadingError: Error?
  
  var stubbedDeleteWishlistJourneyError: Error?
  
  private(set) var createWishlistJourneyCallCount = 0
  private(set) var createHistoryJourneyCallCount = 0
  private(set) var createJourneyCallCount = 0
  private(set) var fetchReadingJourneysCallCount = 0
  private(set) var fetchWishlistCallCount = 0
  private(set) var updateJourneyStatusToReadingCallCount = 0
  private(set) var deleteWishlistJourneyCallCount = 0
  
  private(set) var lastPayload: WishlistTicketPayload?
  private(set) var lastHistoryPayload: HistoryPayload?
  private(set) var lastJourneyPayload: JourneyPayload?
  
  private(set) var receivedJourneyId: String?
  private(set) var receivedStartDate: Date?
  private(set) var receivedCurrentPage: Int?
  
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
  
  func createHistoryJourney(
    payload: HistoryPayload
  ) async throws -> ReadingJourney {
    createHistoryJourneyCallCount += 1
    lastHistoryPayload = payload
    
    if let stubbedCreateHistoryJourneyError {
      throw stubbedCreateHistoryJourneyError
    }
    
    guard let stubbedCreateHistoryJourneyResult else {
      throw MockReadingJourneyError.failed
    }
    
    return stubbedCreateHistoryJourneyResult
  }
  
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
  
  func fetchReadingJourneys() async throws -> [ReadingJourney] {
    fetchReadingJourneysCallCount += 1
    
    if let stubbedFetchReadingJourneysError {
      throw stubbedFetchReadingJourneysError
    }
    
    return stubbedFetchReadingJourneysResult
  }
  
  func fetchWishlist() async throws -> [ReadingJourney] {
    fetchWishlistCallCount += 1
    
    if let stubbedFetchWishlistError {
      throw stubbedFetchWishlistError
    }
    
    return stubbedFetchWishlistResult
  }
  
  func updateJourneyStatusToReading(
    journeyId: String,
    startDate: Date,
    currentPage: Int
  ) async throws -> ReadingJourney {
    updateJourneyStatusToReadingCallCount += 1
    receivedJourneyId = journeyId
    receivedStartDate = startDate
    receivedCurrentPage = currentPage
    
    if let stubbedUpdateJourneyStatusToReadingError {
      throw stubbedUpdateJourneyStatusToReadingError
    }
    
    guard let stubbedUpdatedJourneyResult else {
      throw MockReadingJourneyError.failed
    }
    
    return stubbedUpdatedJourneyResult
  }
  
  func deleteWishlistJourney(
    journeyId: String
  ) async throws {
    deleteWishlistJourneyCallCount += 1
    receivedJourneyId = journeyId
    
    if let stubbedDeleteWishlistJourneyError {
      throw stubbedDeleteWishlistJourneyError
    }
  }
  
  func finishJourney(journeyId: String, review: String) async throws -> Core.ReadingJourney {
    fatalError("Not Used")
  }
  
  func updateJourneyCurrentPage(journeyId: String, currentPage: Int) async throws -> Core.ReadingJourney {
    fatalError("Not Used")
  }
  
  func fetchFinishedJourneys() async throws -> [Core.ReadingJourney] {
    fatalError("Not Used")
  }
  
  func deleteFinishedJourney(journeyId: String) async throws {
    fatalError("Not Used")
  }
}
