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
    onTapBack: (() -> Void)?,
    onTapRegisterBookSearch: ((@escaping (BookInfo) -> Void) -> Void)?,
    onTapSelectDepartureButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onTapSelectDestinationButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onTapCreateTicket: ((BookInfo, AirportInfo, AirportInfo, String) -> Void)?
  ) -> UIViewController
}
