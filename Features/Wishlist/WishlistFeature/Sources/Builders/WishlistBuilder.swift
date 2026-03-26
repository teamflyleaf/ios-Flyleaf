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
    onRoute: @escaping (WishlistRoute) -> Void
  ) -> UIViewController {
    let readingJourneyService = FirebaseReadingJourneyService()
    let viewModel = WishlistViewModel(
      readingJourneyService: readingJourneyService
    )
    
    let viewController = WishlistViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    
    return viewController
  }
}
