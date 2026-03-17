//
//  WishTicketBuilder.swift
//  Wishlist
//
//  Created by 여성일 on 3/16/26.
//

import Core
import UIKit
import WishlistInterface

public final class WishTicketBuilder: WishTicketBuildable {
  public init() {}
  
  public func build(
    payload: WishlistTicketPayload,
    onTapBack: @escaping () -> Void,
    onUploadCompleted: @escaping () -> Void
  ) -> UIViewController {
    let readingJourneyService = FirebaseReadingJourneyService()
    let viewModel = WishTicketViewModel(
      payload: payload,
      readingJourneyService: readingJourneyService
    )
    
    let viewController = WishTicketViewController(viewModel: viewModel)
    viewController.onTapBack = onTapBack
    viewController.onUploadCompleted = onUploadCompleted
    
    return viewController
  }
}
