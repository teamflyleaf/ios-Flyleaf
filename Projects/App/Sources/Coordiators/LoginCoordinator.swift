//
//  LoginCoordinator.swift
//  App
//
//  Created by 여성일 on 3/25/26.
//

import LoginInterface
import UIKit

@MainActor
final class LoginCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  var rootViewController: UIViewController?
  
  private let loginBuilder: LoginBuildable
  
  var onLoginCompleted: (() -> Void)?
  
  init(
    navigationController: UINavigationController,
    loginBuilder: LoginBuildable
  ) {
    self.navigationController = navigationController
    self.loginBuilder = loginBuilder
  }
  
  func start() {
    let loginVC = loginBuilder.build { [weak self] in
      self?.onLoginCompleted?()
    }
    
    rootViewController = loginVC
    navigationController.setViewControllers([loginVC], animated: true)
  }
}
