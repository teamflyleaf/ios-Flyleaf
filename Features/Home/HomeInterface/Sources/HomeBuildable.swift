//
//  HomeBuildable.swift
//  Home
//
//  Created by 여성일 on 3/8/26.
//

import UIKit

public protocol HomeBuildable {
  func build(
    onTapWishlist: @escaping () -> Void,
    onTapJourney: @escaping () -> Void,
    onTapHistory: @escaping () -> Void
  ) -> UIViewController
}
