//
//  WishlistViewModel.swift
//  Wishlist
//
//  Created by 여성일 on 3/20/26.
//

import Core
import Foundation
import TooltipInterface
import ReadingJourneyInterface

public final class WishlistViewModel {
  private let readingJourneyService: ReadingJourneyServicing
  private let tooltipService: TooltipServicing
  
  var onJourneysChanged: (([ReadingJourney]) -> Void)?
  var onLoadingChanged: ((Bool) -> Void)?
  var onError: ((String) -> Void)?
  var onShouldShowWishlistSwipeTooltip: (() -> Void)?
  
  private(set) var journeys: [ReadingJourney] = [] {
    didSet {
      onJourneysChanged?(journeys)
    }
  }
  
  public init(
    readingJourneyService: ReadingJourneyServicing,
    tooltipService: TooltipServicing
  ) {
    self.readingJourneyService = readingJourneyService
    self.tooltipService = tooltipService
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
  
  func checkWishlistSwipeTooltip() {
    guard tooltipService.shouldShowTooltip(for: .wishlistSwipeGuide) else { return }
    tooltipService.markTooltipShown(for: .wishlistSwipeGuide)
    onShouldShowWishlistSwipeTooltip?()
  }
}
