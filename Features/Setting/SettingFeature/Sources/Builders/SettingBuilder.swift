//
//  SettingBuilder.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import AuthInterface
import Core
import SettingInterface
import UIKit


public final class SettingBuilder: SettingBuildable {
  private let authService: AuthServicing
  
  public init(
    authService: AuthServicing
  ) {
    self.authService = authService
  }

  public func build(
    onRoute: @escaping (SettingRoute) -> Void
  ) -> UIViewController {
    let viewModel = SettingViewModel(authService: authService)
    let viewController = SettingViewController(viewModel: viewModel)
    
    viewController.onRoute = onRoute
    
    return viewController
  }
}
