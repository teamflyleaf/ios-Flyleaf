//
//  RegisterWishlistBuildable.swift
//  Wishlist
//
//  Created by 여성일 on 3/13/26.
//

import UIKit

public protocol RegisterWishlistBuildable {
  func build(
    onTapBack: @escaping () -> Void,
    onTapRegisterBookSearch: @escaping () -> Void
  ) -> UIViewController
}
