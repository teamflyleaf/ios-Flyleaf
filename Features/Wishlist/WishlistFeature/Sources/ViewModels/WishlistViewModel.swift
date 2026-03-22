//
//  WishlistViewModel.swift
//  Wishlist
//
//  Created by 여성일 on 3/20/26.
//

import Core
import Foundation

public final class WishlistViewModel {
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
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.readingJourneyService = readingJourneyService
  }
  
  var numberOfItems: Int {
    journeys.count
  }
  
  // MARK: - Public Method
  func loadWishlistJourneys() async {
    onLoadingChanged?(true)
    
    do {
      journeys = try await readingJourneyService.fetchWishlist()
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "예약 목록을 불러오지 못했습니다."
      onError?(message)
    }
    
    onLoadingChanged?(false)
  }
  
  func deleteWishlistJourney(journeyId: String) async {
    do {
      try await readingJourneyService.deleteWishlistJourney(journeyId: journeyId)
      await loadWishlistJourneys()
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "예약 삭제에 실패했습니다."
      onError?(message)
    }
  }
}
