//
//  TermsOfServiceBuilder.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import Core
import SettingInterface
import UIKit

public final class TermsOfServiceBuilder: TermsOfServiceBuildable {
  public init() {}

  public func build(
    onRoute: @escaping (TermsOfServiceRoute) -> Void
  ) -> UIViewController {
    let viewController = TermsOfServiceViewController()
    
    viewController.onRoute = onRoute
    
    return viewController
  }
}
