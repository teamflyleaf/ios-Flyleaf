//
//  WishTicketBuildable.swift
//  Wishlist
//
//  Created by 여성일 on 3/16/26.
//

import Core
import UIKit

public protocol WishTicketBuildable {
  func build(
    payload: WishlistTicketPayload,
    onTapBack: @escaping () -> Void,
    onUploadCompleted: @escaping () -> Void
  ) -> UIViewController
}
