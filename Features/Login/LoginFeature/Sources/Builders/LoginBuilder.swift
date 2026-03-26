//
//  LoginBuilder.swift
//  Login
//
//  Created by 여성일 on 3/8/26.
//

import Core
import LoginInterface
import UIKit

public final class LoginBuilder: LoginBuildable {
  public init() {}
  
  public func build(onLoginSuccess: @escaping () -> Void) -> UIViewController {
    let authService = FirebaseAuthService()
    let viewModel = LoginViewModel(authService: authService)
    let viewController = LoginViewController(viewModel: viewModel)
    viewController.onLoginSuccess = onLoginSuccess
    return viewController
  }
}
