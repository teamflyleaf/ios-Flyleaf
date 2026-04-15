//
//  CheckInWishTicketBuilder.swift
//  Wishlist
//
//  Created by 여성일 on 3/20/26.
//

import Core
import UIKit
import WishlistInterface
import ReadingJourneyInterface

public final class CheckInWishTicketBuilder: CheckInWishTicketBuildable {
  let readingJourneyService: ReadingJourneyServicing
  
  public init(
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.readingJourneyService = readingJourneyService
  }
  
  public func build(
    journey: ReadingJourney,
    onRoute: @escaping (CheckInWishTicketRoute) -> Void
  ) -> UIViewController {
    let viewModel = CheckInWishTicketViewModel(
      journey: journey,
      readingJourneyService: readingJourneyService
    )
    
    let viewController = CheckInWishTicketViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    
    return viewController
  }
}
