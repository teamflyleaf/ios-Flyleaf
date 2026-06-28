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
  private let termsOfServiceBuilder: TermsOfServiceBuildable
  private let openSourceBuilder: OpenSourceBuildable
  private let themeSelectionBuilder: ThemeSelectionBuildable
  
  enum FlowEvent {
    case logout
    case deleteAccount
  }
  
  var onFlowEvent: ((FlowEvent) -> Void)?
  
  init(
    navigationController: UINavigationController,
    settingBuilder: SettingBuildable,
    privacyPolicyBuilder: PrivacyPolicyBuildable,
    termsOfServiceBuilder: TermsOfServiceBuildable,
    openSourceBuilder: OpenSourceBuildable,
    themeSelectionBuilder: ThemeSelectionBuildable
  ) {
    self.navigationController = navigationController
    self.settingBuilder = settingBuilder
    self.privacyPolicyBuilder = privacyPolicyBuilder
    self.termsOfServiceBuilder = termsOfServiceBuilder
    self.openSourceBuilder = openSourceBuilder
    self.themeSelectionBuilder = themeSelectionBuilder
  }
  
  func start() {
    let settingVC = settingBuilder.build(onRoute: { [weak self] route in
      switch route {
      case .back:
        self?.finishFlow()
        
      case .privacyPolicy:
        self?.showPrivacyPolicy()
        
      case .termsOfService:
        self?.showTermsOfService()
      
      case .openSource:
        self?.showOpenSource()
      
      case .logout:
        self?.onFlowEvent?(.logout)
        
      case .deleteAccount:
        self?.onFlowEvent?(.deleteAccount)
        
      case .themeSelection:
        self?.showThemeSelection()
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
  
  func showTermsOfService() {
    let vc = termsOfServiceBuilder.build(
      onRoute: { [weak self] route in
        switch route {
        case .back:
          self?.navigationController.popViewController(animated: true)
        }
      }
    )

    navigationController.pushViewController(vc, animated: true)
  }
  
  func showOpenSource() {
    let vc = openSourceBuilder.build(
      onRoute: { [weak self] route in
        switch route {
        case .back:
          self?.navigationController.popViewController(animated: true)
        }
      }
    )

    navigationController.pushViewController(vc, animated: true)
  }
  
  func showThemeSelection() {
    let vc = themeSelectionBuilder.build(
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
