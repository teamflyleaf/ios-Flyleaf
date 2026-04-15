//
//  LoginBuilder.swift
//  Login
//
//  Created by 여성일 on 3/8/26.
//

import AuthInterface
import AuthImplementation
import Core
import LoginInterface
import UIKit

public final class LoginBuilder: LoginBuildable {
  let authService: AuthServicing
  
  public init(
    authService: AuthServicing
  ) {
    self.authService = authService
  }
  
  public func build(onLoginSuccess: @escaping () -> Void) -> UIViewController {
    let viewModel = LoginViewModel(authService: authService)
    let viewController = LoginViewController(viewModel: viewModel)
    viewController.onLoginSuccess = onLoginSuccess
    return viewController
  }
}
