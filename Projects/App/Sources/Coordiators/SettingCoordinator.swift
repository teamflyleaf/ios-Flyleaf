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
  private let privacyPolicyBuilder: PrivacyPolicyBuildable
  
  init(
    navigationController: UINavigationController,
    settingBuilder: SettingBuildable,
    privacyPolicyBuilder: PrivacyPolicyBuildable
  ) {
    self.navigationController = navigationController
    self.settingBuilder = settingBuilder
    self.privacyPolicyBuilder = privacyPolicyBuilder
  }
  
  func start() {
    let settingVC = settingBuilder.build(onRoute: { [weak self] route in
      switch route {
      case .back:
        self?.finishFlow()
        
      case .privacyPolicy:
        self?.showPrivacyPolicy()
      }
    })
    
    rootViewController = settingVC
    navigationController.pushViewController(settingVC, animated: true)
  }
}

// MARK: - Private
private extension SettingCoordinator {
  func showPrivacyPolicy() {
    let vc = privacyPolicyBuilder.build(
      onRoute: { [weak self] route in
        switch route {
        case .back:
          self?.navigationController.popViewController(animated: true)
        }
      }
    )

    navigationController.pushViewController(vc, animated: true)
  }
}

// MARK: - Finish
private extension SettingCoordinator {
  func finishFlow() {
    navigationController.popViewController(animated: true)
  }
}
