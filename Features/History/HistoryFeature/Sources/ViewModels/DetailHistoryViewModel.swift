//
//  DetailHistoryViewModel.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import Foundation
import ReadingJourneyInterface

public final class DetailHistoryViewModel {
  var onJourneyChanged: ((ReadingJourney) -> Void)?
  var onError: ((String) -> Void)?
  
  private let readingJourneyService: ReadingJourneyServicing
  private(set) var journey: ReadingJourney
  
  public init(
    journey: ReadingJourney,
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.journey = journey
    self.readingJourneyService = readingJourneyService
  }
  
  // MARK: - Public
  func updateFinishedJourneyDates(
    startDate: Date,
    finishDate: Date
  ) async {
    do {
      let updatedJourney = try await readingJourneyService.updateFinishedJourneyDates(
        journeyId: journey.id,
        startDate: startDate,
        finishDate: finishDate
      )
      
      self.journey = updatedJourney
      onJourneyChanged?(updatedJourney)
    } catch {
      onError?(error.localizedDescription)
    }
  }
  
  func updateFinishedJourneyReview(_ review: String) async {
    do {
      let updatedJourney = try await readingJourneyService.updateFinishedJourneyReview(
        journeyId: journey.id,
        review: review
      )
      
      self.journey = updatedJourney
      onJourneyChanged?(updatedJourney)
    } catch {
      onError?(error.localizedDescription)
    }
  }
}
