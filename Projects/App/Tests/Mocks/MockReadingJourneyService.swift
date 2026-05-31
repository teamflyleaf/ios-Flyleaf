//
//  MockReadingJourneyService.swift
//  App
//
//  Created by 여성일 on 5/31/26.
//

import ReadingJourneyInterface
import Foundation

final class MockReadingJourneyService: ReadingJourneyServicing {
  var stubbedFetchReadingJourneysResult: [ReadingJourney] = []
  var stubbedFetchReadingJourneysError: Error?

  func fetchReadingJourneys() async throws -> [ReadingJourney] {
    if let error = stubbedFetchReadingJourneysError { throw error }
    return stubbedFetchReadingJourneysResult
  }

  func createWishlistJourney(payload: WishlistTicketPayload) async throws -> ReadingJourney { fatalError() }
  func createHistoryJourney(payload: HistoryPayload) async throws -> ReadingJourney { fatalError() }
  func createJourney(payload: JourneyPayload) async throws -> ReadingJourney { fatalError() }
  func finishJourney(journeyId: String, review: String) async throws -> ReadingJourney { fatalError() }
  func updateJourneyCurrentPage(journeyId: String, currentPage: Int) async throws -> ReadingJourney { fatalError() }
  func fetchFinishedJourneys() async throws -> [ReadingJourney] { fatalError() }
  func fetchWishlist() async throws -> [ReadingJourney] { fatalError() }
  func updateJourneyStatusToReading(journeyId: String, startDate: Date, currentPage: Int) async throws -> ReadingJourney { fatalError() }
  func updateFinishedJourneyDates(journeyId: String, startDate: Date, finishDate: Date) async throws -> ReadingJourney { fatalError() }
  func updateFinishedJourneyReview(journeyId: String, review: String) async throws -> ReadingJourney { fatalError() }
  func deleteReadingJourney(journeyId: String) async throws { fatalError() }
  func deleteWishlistJourney(journeyId: String) async throws { fatalError() }
  func deleteFinishedJourney(journeyId: String) async throws { fatalError() }
}

enum MockReadingJourneyError: LocalizedError {
  case fetchFailed

  var errorDescription: String? {
    switch self {
    case .fetchFailed: return "여행 데이터를 불러오지 못했습니다."
    }
  }
}
