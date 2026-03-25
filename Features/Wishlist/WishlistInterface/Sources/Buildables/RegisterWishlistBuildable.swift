//
//  RegisterWishlistBuildable.swift
//  Wishlist
//
//  Created by 여성일 on 3/13/26.
//

import Core
import UIKit

public protocol RegisterWishlistBuildable {
  func build(
    onRoute: ((RegisterWishlistRoute) -> Void)?
  ) -> UIViewController
}
