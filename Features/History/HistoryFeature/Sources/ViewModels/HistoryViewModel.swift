//
//  HistoryViewModel.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import Foundation

public final class HistoryViewModel {
  private let readingJourneyService: ReadingJourneyServicing
  
  var onJourneysChanged: (([ReadingJourney]) -> Void)?
  var onLoadingChanged: ((Bool) -> Void)?
  var onError: ((String) -> Void)?
  
  private(set) var journeys: [ReadingJourney] = [] {
    didSet {
      onJourneysChanged?(journeys)
    }
  }
  
  public init(
    readingJourneyService: ReadingJourneyServicing = FirebaseReadingJourneyService()
  ) {
    self.readingJourneyService = readingJourneyService
  }
  
  var numberOfItems: Int {
    journeys.count
  }
  
  // MARK: - Public Method
  func loadFinishedJourneys() async {
    onLoadingChanged?(true)
    
    do {
      journeys = try await readingJourneyService.fetchFinishedJourneys()
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "기록 목록을 불러오지 못했습니다."
      onError?(message)
    }
    
    onLoadingChanged?(false)
  }
  
  func deleteFinishedJourney(journeyId: String) async {
    do {
      try await readingJourneyService.deleteFinishedJourney(journeyId: journeyId)
      await loadFinishedJourneys()
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "기록 삭제에 실패했습니다."
      onError?(message)
    }
  }
}
