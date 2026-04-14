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
import ReadingJourneyInterface

public final class WishlistBuilder: WishlistBuildable {
  let readingJourneyService: ReadingJourneyServicing
  let tooltipService: TooltipServicing
  
  public init(
    readingJourneyService: ReadingJourneyServicing,
    tooltipService: TooltipServicing
  ) {
    self.readingJourneyService = readingJourneyService
    self.tooltipService = tooltipService
  }
  
  public func build(
    onRoute: @escaping (WishlistRoute) -> Void
  ) -> UIViewController {
    let viewModel = WishlistViewModel(
      readingJourneyService: readingJourneyService,
      tooltipService: tooltipService
    )
    
    let viewController = WishlistViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    
    return viewController
  }
}
