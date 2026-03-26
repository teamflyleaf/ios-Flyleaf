//
//  CheckInWishTicketBuilder.swift
//  Wishlist
//
//  Created by 여성일 on 3/20/26.
//

import Core
import UIKit
import WishlistInterface

public final class CheckInWishTicketBuilder: CheckInWishTicketBuildable {
  public init() {}
  
  public func build(
    journey: ReadingJourney,
    onRoute: @escaping (CheckInWishTicketRoute) -> Void
  ) -> UIViewController {
    let readingJourneyService = FirebaseReadingJourneyService()
    let viewModel = CheckInWishTicketViewModel(
      journey: journey,
      readingJourneyService: readingJourneyService
    )
    
    let viewController = CheckInWishTicketViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    
    return viewController
  }
}
