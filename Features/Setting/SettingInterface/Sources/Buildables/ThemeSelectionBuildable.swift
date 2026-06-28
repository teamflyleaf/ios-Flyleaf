//
//  ThemeSelectionBuildable.swift
//  Setting
//
//  Created by 여성일 on 6/28/26.
//

import UIKit

public protocol ThemeSelectionBuildable {
  func build(
    onRoute: @escaping (ThemeSelectionRoute) -> Void
  ) -> UIViewController
}


