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
    onTapBack: (() -> Void)?,
    onTapRegisterBookSearch: ((@escaping (BookInfo) -> Void) -> Void)?,
    onTapSelectDepartureButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onTapSelectDestinationButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onTapCreateTicket: ((BookInfo, AirportInfo, AirportInfo, String) -> Void)?
  ) -> UIViewController {
    let viewModel = RegisterWishlistViewModel()
    let viewController = RegisterWishlistViewController(viewModel: viewModel)

    viewController.onTapBack = onTapBack
    viewController.onTapRegisterBookSearch = onTapRegisterBookSearch
    viewController.onTapSelectDepartureButton = onTapSelectDepartureButton
    viewController.onTapSelectDestinationButton = onTapSelectDestinationButton
    viewController.onTapCreateTicket = onTapCreateTicket
    
    return viewController
  }
}
