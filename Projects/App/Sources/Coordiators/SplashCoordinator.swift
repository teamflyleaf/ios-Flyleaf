//
//  SplashCoordinator.swift
//  App
//
//  Created by 여성일 on 5/31/26.
//

import AuthInterface
import ReadingJourneyInterface
import UIKit

@MainActor
final class SplashCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  var rootViewController: UIViewController?
  
  private let authService: AuthServicing
  private let readingJourneyService: ReadingJourneyServicing
  
  var onNeedsLogin: (() -> Void)?
  var onReadyToMain: (([ReadingJourney]) -> Void)?
  
  init(
    navigationController: UINavigationController,
    authService: AuthServicing,
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.navigationController = navigationController
    self.authService = authService
    self.readingJourneyService = readingJourneyService
  }
  
  func start() {
    let viewModel = SplashViewModel(
      authService: authService,
      readingJourneyService: readingJourneyService
    )
    
    let splashVC = SplashViewController(viewModel: viewModel)
    
    splashVC.onRoute = { [weak self] result in
      switch result {
      case .needsLogin:
        self?.onNeedsLogin?()
      case .readyToMain(let journeys):
        self?.onReadyToMain?(journeys)
      }
    }
    
    navigationController.setViewControllers([splashVC], animated: false)
  }
}
