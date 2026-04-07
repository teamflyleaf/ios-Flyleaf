//
//  JourneyViewModel.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import Core
import Foundation
import TooltipInterface

public final class JourneyViewModel {
  private let readingJourneyService: ReadingJourneyServicing
  private let memoService: JourneyMemoServicing
  private let tooltipService: TooltipServicing
  
  var onMemosChanged: (([JourneyMemo]) -> Void)?
  var onJourneysChanged: (([ReadingJourney]) -> Void)?
  var onLoadingChanged: ((Bool) -> Void)?
  var onError: ((String) -> Void)?
  var onShouldShowCurrentPageTooltip: (() -> Void)?
  
  var memos: [JourneyMemo] = [] {
    didSet {
      onMemosChanged?(memos)
    }
  }
  
  private(set) var journeys: [ReadingJourney] = [] {
    didSet {
      onJourneysChanged?(journeys)
    }
  }
  
  public init(
    readingJourneyService: ReadingJourneyServicing,
    memoService: JourneyMemoServicing,
    tooltipService: TooltipServicing,
  ) {
    self.readingJourneyService = readingJourneyService
    self.memoService = memoService
    self.tooltipService = tooltipService
  }
  
  var numberOfItems: Int {
    journeys.count
  }
  
  // MARK: - Public Method
  func loadReadingJourneys() async {
    onLoadingChanged?(true)
    
    do {
      self.journeys = try await readingJourneyService.fetchReadingJourneys()
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "여행 목록을 불러오지 못했습니다."
      onError?(message)
    }
    
    onLoadingChanged?(false)
  }
  
  func updateCurrentPage(
    journeyId: String,
    currentPage: Int
  ) async {
    do {
      let updatedJourney = try await readingJourneyService.updateJourneyCurrentPage(
        journeyId: journeyId,
        currentPage: currentPage
      )
      
      if let index = self.journeys.firstIndex(where: { $0.id == journeyId }) {
        self.journeys[index] = updatedJourney
      }
    } catch {
      onError?(error.localizedDescription)
    }
  }
  
  func finishJourney(
    journeyId: String,
    review: String
  ) async {
    do {
      _ = try await readingJourneyService.finishJourney(
        journeyId: journeyId,
        review: review
      )
      
      await loadReadingJourneys()
    } catch {
      onError?(error.localizedDescription)
    }
  }
  
  func deleteJourney(journeyId: String) async {
    do {
      try await readingJourneyService.deleteReadingJourney(journeyId: journeyId)
      await loadReadingJourneys()
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "여행 삭제에 실패했습니다."
      onError?(message)
    }
  }
  
  func saveMemo(
    journeyId: String,
    memo: JourneyMemo
  ) async {
    do {
      try await memoService.createMemo(
        journeyId: journeyId,
        memo: memo
      )
      
      await loadMemos(journeyId: journeyId)
    } catch {
      onError?(error.localizedDescription)
    }
  }
  
  func loadMemos(journeyId: String) async {
    do {
      let memos = try await memoService.fetchMemos(journeyId: journeyId)
      self.memos = memos
    } catch {
      onError?(error.localizedDescription)
    }
  }
  
  func updateMemo(
    journeyId: String,
    memo: JourneyMemo
  ) async {
    do {
      try await memoService.updateMemo(
        journeyId: journeyId,
        memo: memo
      )
      
      await loadMemos(journeyId: journeyId)
    } catch {
      onError?(error.localizedDescription)
    }
  }
  
  func deleteMemo(
    journeyId: String,
    memoId: String
  ) async {
    do {
      try await memoService.deleteMemo(
        journeyId: journeyId,
        memoId: memoId
      )
      
      await loadMemos(journeyId: journeyId)
    } catch {
      onError?(error.localizedDescription)
    }
  }
  
  func checkCurrentPageTooltip() {
    guard tooltipService.shouldShowTooltip(for: .journeyCurrentPage) else { return }
    tooltipService.markTooltipShown(for: .journeyCurrentPage)
    onShouldShowCurrentPageTooltip?()
  }
}
