//
//  WishTicketViewModel.swift
//  Wishlist
//
//  Created by 여성일 on 3/16/26.
//

import Core
import Foundation

public final class WishTicketViewModel {
  public let payload: WishlistTicketPayload
  private let readingJourneyService: ReadingJourneyServicing
  
  var onUploadStateChanged: ((Bool) -> Void)?
  var onUploadSuccess: ((ReadingJourney) -> Void)?
  var onError: ((String) -> Void)?
  
  public init(
    payload: WishlistTicketPayload,
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.payload = payload
    self.readingJourneyService = readingJourneyService
  }
  
  // MARK: - Public Method
  func uploadReadingJourney() async {
    onUploadStateChanged?(true)
    
    defer {
      onUploadStateChanged?(false)
    }
    
    do {
      let journey = try await readingJourneyService.createWishlistJourney(
        payload: payload
      )
      onUploadSuccess?(journey)
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "독서 여행 저장에 실패했습니다."
      onError?(message)
    }
  }
}
