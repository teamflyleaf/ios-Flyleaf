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
  
  private var onBookItemSelected: ((BookInfo) -> Void)?
  private var onDepatureAirportSelected: ((AirportInfo) -> Void)?
  private var onDestinationAirportSelected: ((AirportInfo) -> Void)?
  
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
        self?.showRegisterHistory()
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
        self?.showDetailHistory(journey: journey)
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
  
  func moveToJourneyTab() {
    guard let tabBarController = navigationController.viewControllers.first as? MainTabBarController else {
      return
    }
    
    navigationController.popToRootViewController(animated: false)
    tabBarController.selectedIndex = 1
  }
  
  func moveToWishlistTab() {
    guard let tabBarController = navigationController.viewControllers.first as? MainTabBarController else {
      return
    }
    
    navigationController.popToRootViewController(animated: false)
    tabBarController.selectedIndex = 2
  }
  
  func moveToHistoryTab() {
    guard let tabBarController = navigationController.viewControllers.first as? MainTabBarController else {
      return
    }
    
    navigationController.popToRootViewController(animated: false)
    tabBarController.selectedIndex = 3
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

// MARK: - Search
private extension AppCoordinator {
  func showBookSearch() {
    let searchVC = searchBuilder.build(
      type: .book,
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onTapBookItem: { [weak self] item in
        self?.pop(animated: true)
        self?.onBookItemSelected?(item)
        self?.onBookItemSelected = nil
      },
      onTapAirportItem: nil
    )
    
    navigationController.pushViewController(searchVC, animated: true)
  }
  
  func showDepartureAirportSearch() {
    let searchVC = searchBuilder.build(
      type: .departureAirport,
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onTapBookItem: nil,
      onTapAirportItem: { [weak self] item in
        self?.pop(animated: true)
        self?.onDepatureAirportSelected?(item)
        self?.onDepatureAirportSelected = nil
      }
    )
    
    navigationController.pushViewController(searchVC, animated: true)
  }
  
  func showArrivalAirportSearch() {
    let searchVC = searchBuilder.build(
      type: .arrivalAirport,
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onTapBookItem: nil,
      onTapAirportItem: { [weak self] item in
        self?.pop(animated: true)
        self?.onDestinationAirportSelected?(item)
        self?.onDestinationAirportSelected = nil
      }
    )
    
    navigationController.pushViewController(searchVC, animated: true)
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
      switch event {
      case .moveToWishlistTab:
        self?.moveToWishlistTab()
      case .moveToJourneyTab:
        self?.moveToJourneyTab()
      }
    }

    return coordinator
  }
}

// MARK: - History
private extension AppCoordinator {
  func showRegisterHistory() {
    let registerHistoryVC = registerHistoryBuilder.build(
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onTapRegisterBookSearch: { [weak self] onSelected in
        self?.onBookItemSelected = onSelected
        self?.showBookSearch()
      },
      onTapSelectDepartureButton: { [weak self] onSelected in
        self?.onDepatureAirportSelected = onSelected
        self?.showDepartureAirportSearch()
      },
      onTapSelectDestinationButton: { [weak self] onSelected in
        self?.onDestinationAirportSelected = onSelected
        self?.showArrivalAirportSearch()
      },
      onUploadCompleted: { [weak self] in
        self?.moveToHistoryTab()
      }
    )
    navigationController.pushViewController(registerHistoryVC, animated: true)
  }
  
  func showDetailHistory(journey: ReadingJourney) {
    let vc = detailHistoryBuilder.build(
      journey: journey,
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      }
    )
    
    navigationController.pushViewController(vc, animated: true)
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
        self?.moveToJourneyTab()
      }
    }
    
    return coordinator
  }
}
