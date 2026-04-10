//
//  WishTicketBuildable.swift
//  Wishlist
//
//  Created by 여성일 on 3/16/26.
//

import Core
import UIKit
import ReadingJourneyInterface

public protocol WishTicketBuildable {
  func build(
    payload: WishlistTicketPayload,
    onRoute: @escaping (WishTicketRoute) -> Void
  ) -> UIViewController
}
