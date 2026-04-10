//
//  CheckInWishTicketBuildable.swift
//  Wishlist
//
//  Created by 여성일 on 3/20/26.
//

import Core
import UIKit
import ReadingJourneyInterface

public protocol CheckInWishTicketBuildable {
  func build(
    journey: ReadingJourney,
    onRoute: @escaping (CheckInWishTicketRoute) -> Void
  ) -> UIViewController
}
