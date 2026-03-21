//
//  WishlistBuilder.swift
//  Wishlist
//
//  Created by 여성일 on 3/20/26.
//

import Core
import UIKit
import WishlistInterface

public final class WishlistBuilder: WishlistBuildable {
  public init() {}
  
  public func build(
    onTapCheckIn: @escaping (ReadingJourney) -> Void
  ) -> UIViewController {
    let readingJourneyService = FirebaseReadingJourneyService()
    let viewModel = WishlistViewModel(
      readingJourneyService: readingJourneyService
    )
    
    let viewController = WishlistViewController(viewModel: viewModel)
    viewController.onTapCheckIn = onTapCheckIn
    
    return viewController
  }
}
