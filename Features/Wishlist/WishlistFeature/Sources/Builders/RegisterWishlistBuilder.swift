//
//  RegisterWishlistBuilder.swift
//  Wishlist
//
//  Created by 여성일 on 3/13/26.
//

import UIKit
import WishlistInterface

public final class RegisterWishlistBuilder: RegisterWishlistBuildable {
  public init() {}

  public func build(
    onTapBack: @escaping () -> Void,
    onTapRegisterBookSearch: @escaping () -> Void
  ) -> UIViewController {
    let viewModel = RegisterWishlistViewModel()
    let viewController = RegisterWishlistViewController(viewModel: viewModel)

    viewController.onTapBack = onTapBack
    viewController.onTapRegisterBookSearch = onTapRegisterBookSearch

    return viewController
  }
}
