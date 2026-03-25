//
//  AppCoordinator.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/6/26.
//

import Core
import HomeInterface
import LoginInterface
import SearchInterface
import WishlistInterface
import HistoryInterface
import JourneyInterface
import UIKit

@MainActor
final class AppCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  
  private let authService: AuthServicing
  private let homeBuilder: HomeBuildable
  private let loginBuilder: LoginBuildable
  private let searchBuilder: SearchBuildable
  private let wishlistBuilder: WishlistBuildable
  private let checkInWishTicketBuilder: CheckInWishTicketBuildable
  private let registerWishlistBuilder: RegisterWishlistBuildable
  private let wishTicketBuilder: WishTicketBuildable
  private let journeyTicketBuilder: JourneyTicketBuildable
  private let registerHistoryBuilder: RegisterHistoryBuildable
  private let registerJourneyBuilder: RegisterJourneyBuildable
  private let jourenyBuilder: JourneyBuildable
  private let historyBuilder: HistoryBuildable
  private let detailHistoryBuilder: DetailHistoryBuildable
  
  init(
    navigationController: UINavigationController,
    authService: AuthServicing,
    homeBuilder: HomeBuildable,
    loginBuilder: LoginBuildable,
    searchBuilder: SearchBuildable,
    wishlistBuilder: WishlistBuildable,
    checkInWishTicketBuilder: CheckInWishTicketBuildable,
    registerWishlistBuilder: RegisterWishlistBuildable,
    wishTicketBuilder: WishTicketBuildable,
    journeyTicketBuilder: JourneyTicketBuildable,
    registerHistoryBuilder: RegisterHistoryBuildable,
    registerJourneyBuilder: RegisterJourneyBuildable,
    jourenyBuilder: JourneyBuildable,
    historyBuilder: HistoryBuildable,
    detailHistoryBuilder: DetailHistoryBuildable
  ) {
    self.navigationController = navigationController
    self.authService = authService
    self.homeBuilder = homeBuilder
    self.loginBuilder = loginBuilder
    self.searchBuilder = searchBuilder
    self.wishlistBuilder = wishlistBuilder
    self.checkInWishTicketBuilder = checkInWishTicketBuilder
    self.registerWishlistBuilder = registerWishlistBuilder
    self.wishTicketBuilder = wishTicketBuilder
    self.journeyTicketBuilder = journeyTicketBuilder
    self.registerHistoryBuilder = registerHistoryBuilder
    self.registerJourneyBuilder = registerJourneyBuilder
    self.jourenyBuilder = jourenyBuilder
    self.historyBuilder = historyBuilder
    self.detailHistoryBuilder = detailHistoryBuilder
  }
  
  func start() {
    routeInitialFlow()
  }
  
  private func routeInitialFlow() {
    if authService.isSignedIn {
      showMainTabBar()
    } else {
      showLogin()
    }
  }
}

// MARK: - MainTabBar
private extension AppCoordinator {
  func showMainTabBar() {
    let homeVC = homeBuilder.build(
      onTapWishlist: { [weak self] in
        self?.startWishlistFlow()
      },
      onTapJourney: { [weak self] in
        self?.startJourneyFlow()
      },
      onTapHistory: { [weak self] in
        self?.startHistoryFlow()
      }
    )
    let journeyVC = jourenyBuilder.build()
    
    let wishlistVC = wishlistBuilder.build(
      onTapCheckIn: { [weak self] journey in
        self?.startCheckInWishlistFlow(journey: journey)
      }
    )
    
    let historyVC = historyBuilder.build(
      onTapHistory: { [weak self] journey in
        self?.startDetailHistoryFlow(journey: journey)
      }
    )
    
    let tabBarController = MainTabBarController(
      homeViewController: homeVC,
      journeyViewController: journeyVC,
      wishlistViewController: wishlistVC,
      historyViewController: historyVC
    )
    
    navigationController.setViewControllers([tabBarController], animated: true)
  }
  
  func moveToTab(_ tab: Tab) {
    guard let tabBarController = navigationController.viewControllers.first as? MainTabBarController else {
      return
    }
    navigationController.popToRootViewController(animated: false)
    tabBarController.selectedIndex = tab.rawValue
  }
}

// MARK: - Login
private extension AppCoordinator {
  func showLogin() {
    let coordinator = LoginCoordinator(
      navigationController: navigationController,
      loginBuilder: loginBuilder
    )
    coordinator.parentCoordinator = self
    coordinator.onLoginCompleted = { [weak self] in
      guard let self = self else { return }
      self.showMainTabBar()
      self.childDidFinish(coordinator)
    }
    
    childCoordinators.append(coordinator)
    coordinator.start()
  }
}

// MARK: - Wishlist
private extension AppCoordinator {
  func startWishlistFlow() {
    let coordinator = makeWishlistCoordinator()
    childCoordinators.append(coordinator)
    coordinator.start()
  }
  
  func startCheckInWishlistFlow(journey: ReadingJourney) {
    let coordinator = makeWishlistCoordinator()
    childCoordinators.append(coordinator)
    coordinator.startCheckInFlow(journey: journey)
  }
  
  func makeWishlistCoordinator() -> WishlistCoordinator {
    let coordinator = WishlistCoordinator(
      navigationController: navigationController,
      registerWishlistBuilder: registerWishlistBuilder,
      wishTicketBuilder: wishTicketBuilder,
      checkInWishTicketBuilder: checkInWishTicketBuilder,
      searchBuilder: searchBuilder
    )
    
    coordinator.parentCoordinator = self
    coordinator.onFlowEvent = { [weak self] event in
      guard let self = self else { return }
      switch event {
      case .moveToWishlistTab:
        self.moveToTab(.wishlist)
      case .moveToJourneyTab:
        self.moveToTab(.journey)
      }
    }
    
    return coordinator
  }
}

// MARK: - History
private extension AppCoordinator {
  func startHistoryFlow() {
    let coordinator = makeHistoryCoordinator()
    childCoordinators.append(coordinator)
    coordinator.start()
  }
  
  func startDetailHistoryFlow(journey: ReadingJourney) {
    let coordinator = makeHistoryCoordinator()
    childCoordinators.append(coordinator)
    coordinator.startDetailFlow(journey: journey)
  }
  
  func makeHistoryCoordinator() -> HistoryCoordinator {
    let coordinator = HistoryCoordinator(
      navigationController: navigationController,
      registerHistoryBuilder: registerHistoryBuilder,
      detailHistoryBuilder: detailHistoryBuilder,
      searchBuilder: searchBuilder
    )
    
    coordinator.parentCoordinator = self
    coordinator.onFlowEvent = { [weak self] event in
      switch event {
      case .moveToHistoryTab:
        self?.moveToTab(.history)
      }
    }
    
    return coordinator
  }
}

// MARK: - Journey
private extension AppCoordinator {
  func startJourneyFlow() {
    let coordinator = makeJourneyCoordinator()
    childCoordinators.append(coordinator)
    coordinator.start()
  }
  
  func makeJourneyCoordinator() -> JourneyCoordinator {
    let coordinator = JourneyCoordinator(
      navigationController: navigationController,
      registerJourneyBuilder: registerJourneyBuilder,
      journeyTicketBuilder: journeyTicketBuilder,
      searchBuilder: searchBuilder
    )
    
    coordinator.parentCoordinator = self
    coordinator.onFlowEvent = { [weak self] event in
      switch event {
      case .moveToJourneyTab:
        self?.moveToTab(.journey)
      }
    }
    
    return coordinator
  }
}
