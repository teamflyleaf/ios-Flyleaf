//
//  AppCoordinator.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/6/26.
//

import UIKit
import LoginFeature
import HomeFeature

final class AppCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    showLogin()
  }
  
  private func showLogin() {
    let viewModel = LoginViewModel()
    let loginVC = LoginViewController(viewModel: viewModel)
    
    loginVC.onLoginSuccess = { [weak self] in
      self?.showHome()
    }
    navigationController.setViewControllers([loginVC], animated: true)
  }
  
  private func showHome() {
    let viewModel = HomeViewModel()
    let homeVC = HomeViewController(viewModel: viewModel)
    
    navigationController.setViewControllers([homeVC], animated: true)
  }
}
