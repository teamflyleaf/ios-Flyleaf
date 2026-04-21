//
//  SettingCoordinator.swift
//  App
//
//  Created by 여성일 on 4/21/26.
//

import SettingInterface
import UIKit

@MainActor
final class SettingCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  var rootViewController: UIViewController?
  
  private let settingBuilder: SettingBuildable
  
  init(
    navigationController: UINavigationController,
    settingBuilder: SettingBuildable
  ) {
    self.navigationController = navigationController
    self.settingBuilder = settingBuilder
  }
  
  func start() {
    let settingVC = settingBuilder.build(onRoute: { [weak self] route in
      switch route {
      case .back:
        self?.finishFlow()
      }
    })
    
    rootViewController = settingVC
    navigationController.pushViewController(settingVC, animated: true)
  }
}

// MARK: - Finish
private extension SettingCoordinator {
  func finishFlow() {
    navigationController.popViewController(animated: true)
  }
}
