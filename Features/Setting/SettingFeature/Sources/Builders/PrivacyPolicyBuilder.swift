//
//  PrivacyPolicyBuilder.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import Core
import SettingInterface
import UIKit

public final class PrivacyPolicyBuilder: PrivacyPolicyBuildable {
  public init() {}

  public func build(
    onRoute: @escaping (PrivacyPolicyRoute) -> Void
  ) -> UIViewController {
    let viewController = PrivacyPolicyViewController()
    
    viewController.onRoute = onRoute
    
    return viewController
  }
}
