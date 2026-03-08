//
//  AppCoordinator.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/6/26.
//

import Core
import HomeInterface
import LoginInterface
import UIKit

final class AppCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  
  private let authService: AuthServicing
  private let homeBuilder: HomeBuildable
  private let loginBuilder: LoginBuildable

  init(
    navigationController: UINavigationController,
    authService: AuthServicing,
    homeBuilder: HomeBuildable,
    loginBuilder: LoginBuildable
  ) {
    self.navigationController = navigationController
    self.authService = authService
    self.homeBuilder = homeBuilder
    self.loginBuilder = loginBuilder
  }
  
  func start() {
    routeInitialFlow()
  }
  
  private func routeInitialFlow() {
    if authService.isSignedIn {
      showHome()
    } else {
      showLogin()
    }
  }
  
  private func showLogin() {
    let loginVC = loginBuilder.build { [weak self] in
      DispatchQueue.main.async {
        self?.showHome()
      }
    }
    
    navigationController.setViewControllers([loginVC], animated: true)
  }
  
  private func showHome() {
    let homeVC = homeBuilder.build()
    
    navigationController.setViewControllers([homeVC], animated: true)
  }
}
