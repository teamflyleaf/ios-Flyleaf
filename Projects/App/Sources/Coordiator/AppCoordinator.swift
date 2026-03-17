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
  private let registerWishlistBuilder: RegisterWishlistBuildable
  private let wishTicketBuilder: WishTicketBuildable
  
  init(
    navigationController: UINavigationController,
    authService: AuthServicing,
    homeBuilder: HomeBuildable,
    loginBuilder: LoginBuildable,
    searchBuilder: SearchBuildable,
    registerWishlistBuilder: RegisterWishlistBuildable,
    wishTicketBuilder: WishTicketBuildable,
  ) {
    self.navigationController = navigationController
    self.authService = authService
    self.homeBuilder = homeBuilder
    self.loginBuilder = loginBuilder
    self.searchBuilder = searchBuilder
    self.registerWishlistBuilder = registerWishlistBuilder
    self.wishTicketBuilder = wishTicketBuilder
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
  
  private func showLogin() {
    let loginVC = loginBuilder.build { [weak self] in
      self?.showMainTabBar()
    }
    
    navigationController.setViewControllers([loginVC], animated: true)
  }
  
  private func showBookSearch() {
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
  
  private func showDepartureAirportSearch() {
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
  
  private func showArrivalAirportSearch() {
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
  
  private func showMainTabBar() {
    let homeVC = homeBuilder.build(
      onTapWishlist: { [weak self] in
        self?.showRegisterWishlist()
      },
      onTapJourney: {},
      onTapHistory: {}
    )
    let journeyVC = PlaceholderViewController()
    let wishlistVC = PlaceholderViewController()
    let historyVC = PlaceholderViewController()
    
    let tabBarController = MainTabBarController(
      homeViewController: homeVC,
      journeyViewController: journeyVC,
      wishlistViewController: wishlistVC,
      historyViewController: historyVC
    )
    
    navigationController.setViewControllers([tabBarController], animated: true)
  }
  
  private func showRegisterWishlist() {
    let registerWishlistVC = registerWishlistBuilder.build(
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
      onTapCreateTicket: { [weak self] book, departure, destination, reason in
        self?.showWishTicket(
          book: book,
          departure: departure,
          destination: destination,
          reason: reason
        )
      }
    )
    navigationController.pushViewController(registerWishlistVC, animated: true)
  }
  
  private func moveToWishlistTab() {
    guard let tabBarController = navigationController.viewControllers.first as? MainTabBarController else {
      return
    }
    
    navigationController.popToRootViewController(animated: false)
    tabBarController.selectedIndex = 2
  }
  
  private func showWishTicket(
    book: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    reason: String
  ) {
    let payload = WishlistTicketPayload(
      book: book,
      departure: departure,
      destination: destination,
      reason: reason
    )
    
    let ticketVC = wishTicketBuilder.build(
      payload: payload,
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onUploadCompleted: { [weak self] in 
        self?.moveToWishlistTab()
      }
    )

    navigationController.pushViewController(ticketVC, animated: true)
  }
}
