//
//  CheckInWishViewModel.swift
//  Wishlist
//
//  Created by 여성일 on 3/20/26.
//

import Core
import Foundation

public final class CheckInWishTicketViewModel {
  public let journey: ReadingJourney
  private let readingJourneyService: ReadingJourneyServicing
  
  var onUploadStateChanged: ((Bool) -> Void)?
  var onUploadSuccess: ((ReadingJourney) -> Void)?
  var onError: ((String) -> Void)?
  
  public init(
    journey: ReadingJourney,
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.journey = journey
    self.readingJourneyService = readingJourneyService
  }
  
  var payload: JourneyPayload {
    JourneyPayload(
      book: journey.book,
      startDate: Date(),
      currentPage: 0,
      departureAirport: journey.departureAirport,
      destinationAirport: journey.arrivalAirport
    )
  }
  
  // MARK: - Public Method
  func uploadReadingJourney() async {
    onUploadStateChanged?(true)
    
    defer {
      onUploadStateChanged?(false)
    }
    
    do {
      let updatedJourney = try await readingJourneyService.updateJourneyStatusToReading(
        journeyId: journey.id,
        startDate: Date(),
        currentPage: 0
      )
      onUploadSuccess?(updatedJourney)
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "체크인에 실패했습니다."
      onError?(message)
    }
  }
}
