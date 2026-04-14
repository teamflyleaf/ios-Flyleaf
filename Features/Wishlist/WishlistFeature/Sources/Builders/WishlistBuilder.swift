//
//  WishlistBuilder.swift
//  Wishlist
//
//  Created by 여성일 on 3/20/26.
//

import Core
import UIKit
import WishlistInterface
import TooltipInterface
import ReadingJourneyImplementation

public final class WishlistBuilder: WishlistBuildable {
  let tooltipService: TooltipServicing
  
  public init(
    tooltipService: TooltipServicing
  ) {
    self.tooltipService = tooltipService
  }
  
  public func build(
    onRoute: @escaping (WishlistRoute) -> Void
  ) -> UIViewController {
    let readingJourneyService = ReadingJourneyService()
    let tooltipService = tooltipService
    let viewModel = WishlistViewModel(
      readingJourneyService: readingJourneyService,
      tooltipService: tooltipService
    )
    
    let viewController = WishlistViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    
    return viewController
  }
}
