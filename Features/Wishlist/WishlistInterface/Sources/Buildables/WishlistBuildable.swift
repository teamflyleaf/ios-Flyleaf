//
//  WishlistBuildable.swift
//  Wishlist
//
//  Created by 여성일 on 3/20/26.
//

import Core
import UIKit

public protocol WishlistBuildable {
  func build(
    onRoute: @escaping (WishlistRoute) -> Void
  ) -> UIViewController
}
