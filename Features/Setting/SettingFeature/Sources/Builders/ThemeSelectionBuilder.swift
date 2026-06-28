//
//  ThemeSelectionBuilder.swift
//  Setting
//
//  Created by 여성일 on 6/28/26.
//

import Core
import SettingInterface
import UIKit

public final class ThemeSelectionBuilder: ThemeSelectionBuildable {
  public init() {}

  public func build(
    onRoute: @escaping (ThemeSelectionRoute) -> Void
  ) -> UIViewController {
    let viewController = ThemeSelectionViewController()
    
    viewController.onRoute = onRoute
    
    return viewController
  }
}
