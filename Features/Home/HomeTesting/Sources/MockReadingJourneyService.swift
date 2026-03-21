//
//  MockReadingJourneyService.swift
//  Home
//
//  Created by 여성일 on 3/20/26.
//

import Core
import Foundation

final class MockReadingJourneyService: ReadingJourneyServicing {
  var stubbedFetchReadingJourneysResult: [ReadingJourney] = []
  var stubbedFetchReadingJourneysError: Error?
  
  func fetchReadingJourneys() async throws -> [ReadingJourney] {
    if let error = stubbedFetchReadingJourneysError {
      throw error
    }
    return stubbedFetchReadingJourneysResult
  }
  
  func createWishlistJourney(
    payload: WishlistTicketPayload
  ) async throws -> ReadingJourney {
    fatalError("Not used in HomeViewModelTests")
  }
  
  func createHistoryJourney(
    payload: HistoryPayload
  ) async throws -> ReadingJourney {
    fatalError("Not used in HomeViewModelTests")
  }
  
  func createJourney(
    payload: JourneyPayload
  ) async throws -> ReadingJourney {
    fatalError("Not used in HomeViewModelTests")
  }
  
  func fetchWishlist() async throws -> [ReadingJourney] {
    fatalError("Not used in HomeViewModelTests")
  }
  
  func updateJourneyStatusToReading(journeyId: String, startDate: Date, currentPage: Int) async throws -> ReadingJourney {
    fatalError("Not used in HomeViewModelTests")
  }
  
  func deleteWishlistJourney(journeyId: String) async throws {
    fatalError("Not used in HomeViewModelTests")
  }
}
