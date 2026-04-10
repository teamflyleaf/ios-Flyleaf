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
import ReadingJourneyImplementation

public final class CheckInWishTicketBuilder: CheckInWishTicketBuildable {
  public init() {}
  
  public func build(
    journey: ReadingJourney,
    onRoute: @escaping (CheckInWishTicketRoute) -> Void
  ) -> UIViewController {
    let readingJourneyService = ReadingJourneyService()
    let viewModel = CheckInWishTicketViewModel(
      journey: journey,
      readingJourneyService: readingJourneyService
    )
    
    let viewController = CheckInWishTicketViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    
    return viewController
  }
}
