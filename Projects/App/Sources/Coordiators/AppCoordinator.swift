//
//  AppCoordinator.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/6/26.
//

import Core
import AuthInterface
import HomeInterface
import LoginInterface
import SearchInterface
import WishlistInterface
import HistoryInterface
import JourneyInterface
import ReadingJourneyInterface
import SettingInterface
import UIKit

@MainActor
final class AppCoordinator: NSObject, Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  var rootViewController: UIViewController?
  
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
  private let settingBuilder: SettingBuildable
  private let privacyPolicyBuilder: PrivacyPolicyBuildable
  private let termsOfServiceBuilder: TermsOfServiceBuildable
  private let openSourceBuilder: OpenSourceBuildable
  
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
    detailHistoryBuilder: DetailHistoryBuildable,
    settingBuilder: SettingBuildable,
    privacyPolicyBuilder: PrivacyPolicyBuildable,
    termsOfServiceBuilder: TermsOfServiceBuildable,
    openSourceBuilder: OpenSourceBuildable
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
    self.settingBuilder = settingBuilder
    self.privacyPolicyBuilder = privacyPolicyBuilder
    self.termsOfServiceBuilder = termsOfServiceBuilder
    self.openSourceBuilder = openSourceBuilder
    
    super.init()
    
    self.navigationController.delegate = self
  }
  
  func start() {
    // routeInitialFlow은 case 3때 활용
    // routeInitialFlow()
    showSplash()
  }
  
  private func showSplash() {
    let viewModel = SplashViewModel(authService: authService)
    let splashVC = SplashViewController(viewModel: viewModel)
    
    splashVC.onRoute = { [weak self] result in
      switch result {
      case .needsLogin:
        self?.showLogin()
      }
    }
    
    navigationController.setViewControllers([splashVC], animated: false)
  }
  
  // routeInitialFlow은 case 3때 활용
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
      onRoute: { [weak self] route in
        switch route {
        case .wishlist:
          self?.startWishlistFlow()
        case .journey:
          self?.startJourneyFlow()
        case .history:
          self?.startHistoryFlow()
        case .setting:
          self?.startSettingFlow()
        }
      }
    )
    
    let journeyVC = jourenyBuilder.build(
      onRoute: { [weak self] route in
        switch route {
        case .addJourney:
          self?.startJourneyFlow()
        }
      }
    )
    
    let wishlistVC = wishlistBuilder.build(
      onRoute: { [weak self] route in
        switch route {
        case .checkIn(let journey):
          self?.startCheckInWishlistFlow(journey: journey)
        case .addWish:
          self?.startWishlistFlow()
        }
      }
    )
    
    let historyVC = historyBuilder.build(
      onRoute: { [weak self] route in
        switch route {
        case .detail(let journey):
          self?.startDetailHistoryFlow(journey: journey)
        case .addHistory:
          self?.startHistoryFlow()
        }
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

// MARK: - UINavigationControllerDelegate
extension AppCoordinator: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
    
    if navigationController.viewControllers.contains(fromViewController) {
      return
    }
    
    removeFinishedCoordinator(
      from: childCoordinators,
      poppedViewController: fromViewController
    )
  }
  
  private func removeFinishedCoordinator(
    from coordinators: [Coordinator],
    poppedViewController: UIViewController
  ) {
    for coordinator in coordinators {
      if coordinator.rootViewController === poppedViewController {
        childDidFinish(coordinator)
        return
      }
      
      removeFinishedCoordinator(
        from: coordinator.childCoordinators,
        poppedViewController: poppedViewController
      )
    }
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

// MARK: - Setting
private extension AppCoordinator {
  func startSettingFlow() {
    let coordinator = makeSettingCoordinator()
    childCoordinators.append(coordinator)
    coordinator.start()
  }
  
  func makeSettingCoordinator() -> SettingCoordinator {
    let coordinator = SettingCoordinator(
      navigationController: navigationController,
      settingBuilder: settingBuilder,
      privacyPolicyBuilder: privacyPolicyBuilder,
      termsOfServiceBuilder: termsOfServiceBuilder,
      openSourceBuilder: openSourceBuilder
    )
    
    coordinator.parentCoordinator = self
    coordinator.onFlowEvent = { [weak self] event in
      switch event {
      case .logout:
        self?.childCoordinators.removeAll()
        self?.showLogin()
        
      case .deleteAccount:
        self?.childCoordinators.removeAll()
        self?.showLogin()
      }
    }
    return coordinator
  }
}
