//
//  RegisterWishlistBuilder.swift
//  Wishlist
//
//  Created by 여성일 on 3/13/26.
//

import Core
import UIKit
import WishlistInterface

public final class RegisterWishlistBuilder: RegisterWishlistBuildable {
  public init() {}
  public func build(
    onRoute: ((RegisterWishlistRoute) -> Void)?
  ) -> UIViewController {
    let viewModel = RegisterWishlistViewModel()
    let viewController = RegisterWishlistViewController(viewModel: viewModel)

    viewController.onRoute = onRoute
    
    return viewController
  }
}
