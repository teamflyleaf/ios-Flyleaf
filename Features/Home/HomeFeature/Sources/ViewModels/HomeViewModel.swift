//
//  HomeViewModel.swift
//  Home
//
//  Created by 여성일 on 3/7/26.
//

import Core
import Foundation
import ReadingJourneyInterface

public final class HomeViewModel {
  private let readingJourneyService: ReadingJourneyServicing

  var onJourneysChanged: (([ReadingJourney]) -> Void)?
  var onError: ((String) -> Void)?
  
  private(set) var journeys: [ReadingJourney] = [] {
    didSet {
      onJourneysChanged?(journeys)
    }
  }
  
  public init(
    readingJourneyService: ReadingJourneyServicing,
    preloadedJourneys: [ReadingJourney] = []
  ) {
    self.readingJourneyService = readingJourneyService
    self.journeys = preloadedJourneys
  }
  
  var greetingText: String {
    let hour = Calendar.current.component(.hour, from: Date())
    
    switch hour {
    case 5..<11:
      return "좋은 아침이에요"
    case 11..<17:
      return "좋은 오후에요"
    case 17..<21:
      return "좋은 저녁이에요"
    default:
      return "편안한 밤이에요"
    }
  }
  
  var tripCount: Int {
    journeys.count
  }
  
  var totalDistance: Int {
    Int(journeys.reduce(0) { $0 + $1.distanceKm })
  }
  
  var latestJourney: ReadingJourney? {
    journeys.max { $0.lastUpdatedAt < $1.lastUpdatedAt }
  }
  
  // MARK: - Public Method
  func calculateProgress(journey: ReadingJourney) -> Double {
    guard let currentPage = journey.currentPage, journey.book.itemPage > 0 else {
      return 0
    }
    
    return min(max(Double(currentPage) / Double(journey.book.itemPage), 0), 1)
  }
  
  func refresh() async {
    do {
      journeys = try await readingJourneyService.fetchReadingJourneys()
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "여행 데이터를 불러오지 못했습니다."
      onError?(message)
    }
  }
}
