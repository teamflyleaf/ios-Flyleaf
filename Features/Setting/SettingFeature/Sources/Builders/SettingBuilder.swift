//
//  SettingBuilder.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import Core
import SettingInterface
import UIKit

public final class SettingBuilder: SettingBuildable {
  public init() {}

  public func build(
    onRoute: @escaping (SettingRoute) -> Void
  ) -> UIViewController {
    let viewController = SettingViewController()
    
    viewController.onRoute = onRoute
    
    return viewController
  }
}
