//
//  WishTicketBuilder.swift
//  Wishlist
//
//  Created by 여성일 on 3/16/26.
//

import Core
import UIKit
import WishlistInterface
import ReadingJourneyImplementation
import ReadingJourneyInterface

public final class WishTicketBuilder: WishTicketBuildable {
  let readingJourneyService: ReadingJourneyServicing
  
  public init(
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.readingJourneyService = readingJourneyService
  }
  
  public func build(
    payload: WishlistTicketPayload,
    onRoute: @escaping (WishTicketRoute) -> Void
  ) -> UIViewController {
    let viewModel = WishTicketViewModel(
      payload: payload,
      readingJourneyService: readingJourneyService
    )
    
    let viewController = WishTicketViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    return viewController
  }
}
