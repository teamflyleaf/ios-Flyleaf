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
  
  var stubbedFetchFinishedJourneysResult: [ReadingJourney] = []
  var stubbedFetchFinishedJourneysError: Error?
  
  var stubbedDeleteFinishedJourneyError: Error?
  
  private(set) var createWishlistJourneyCallCount = 0
  private(set) var createHistoryJourneyCallCount = 0
  private(set) var fetchFinishedJourneysCallCount = 0
  private(set) var deleteFinishedJourneyCallCount = 0
  private(set) var lastDeletedFinishedJourneyId: String?
  
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
  
  func fetchWishlist() async throws -> [ReadingJourney] {
    fatalError("Not used")
  }
  
  func updateJourneyStatusToReading(
    journeyId: String,
    startDate: Date,
    currentPage: Int
  ) async throws -> ReadingJourney {
    fatalError("Not used")
  }
  
  func deleteWishlistJourney(journeyId: String) async throws {
    fatalError("Not used")
  }
  
  func finishJourney(journeyId: String, review: String) async throws -> ReadingJourney {
    fatalError("Not used")
  }
  
  func updateJourneyCurrentPage(journeyId: String, currentPage: Int) async throws -> ReadingJourney {
    fatalError("Not used")
  }
  
  func fetchFinishedJourneys() async throws -> [ReadingJourney] {
    fetchFinishedJourneysCallCount += 1
    
    if let stubbedFetchFinishedJourneysError {
      throw stubbedFetchFinishedJourneysError
    }
    
    return stubbedFetchFinishedJourneysResult
  }
  
  func deleteFinishedJourney(journeyId: String) async throws {
    deleteFinishedJourneyCallCount += 1
    lastDeletedFinishedJourneyId = journeyId
    
    if let stubbedDeleteFinishedJourneyError {
      throw stubbedDeleteFinishedJourneyError
    }
  }
}
