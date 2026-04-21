//
//  OpenSourceBuilder.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import Core
import SettingInterface
import UIKit

public final class OpenSourceBuilder: OpenSourceBuildable {
  public init() {}

  public func build(
    onRoute: @escaping (OpenSourceRoute) -> Void
  ) -> UIViewController {
    let viewController = OpenSourceViewController()
    
    viewController.onRoute = onRoute
    
    return viewController
  }
}
