//
//  OnboardingCoordinator.swift
//  App
//
//  Created by 여성일 on 6/15/26.
//

import OnboardingFeature
import UIKit

@MainActor
final class OnboardingCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  var rootViewController: UIViewController?
  
  var onCompleted: (() -> Void)?

  init(
    navigationController: UINavigationController
  ) {
    self.navigationController = navigationController
  }
  
  func start() {
    showPage1()
  }
}

// MARK: - Private
private extension OnboardingCoordinator {
  func trainsition(_ vc: UIViewController) {
    UIView.transition(
      with: navigationController.view,
     duration: 0.5,
     options: .transitionCrossDissolve
    ) {
      self.navigationController.setViewControllers([vc], animated: false)
    }
  }
  
  func showPage1() {
    let vc = OnboardingPage1ViewController()
    vc.onCompleted = { [weak self] in
      self?.showPage2()
    }
    navigationController.setViewControllers([vc], animated: false)
  }
  
  func showPage2() {
    let vc = OnboardingPage2ViewController()
    vc.onCompleted = { [weak self] in
      self?.showPage3()
    }
    trainsition(vc)
  }
  
  func showPage3() {
    let vc = OnboardingPage3ViewController()
    vc.onCompleted = { [weak self] in
      self?.showPage4()
    }
    trainsition(vc)
  }
  
  func showPage4() {
    let vc = OnboardingPage4ViewController()
    trainsition(vc)
  }
}
