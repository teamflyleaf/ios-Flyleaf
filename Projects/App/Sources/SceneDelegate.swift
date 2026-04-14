//
//  SceneDelegate.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/1/26.
//

import AuthImplementation
import Core
import HomeFeature
import LoginFeature
import UIKit
import SearchFeature
import WishlistFeature
import HistoryFeature
import JourneyFeature
import AirportSearchImplementation
import BookSearchImplementation
import SearchHistoryImplementation
import TooltipImplementation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  var appCoordinator: AppCoordinator?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    
    guard let windowScene = scene as? UIWindowScene else { return }
    
    URLCache.shared = URLCache(
      memoryCapacity: 30 * 1024 * 1024,
      diskCapacity: 300 * 1024 * 1024
    )
    
    let navigationController = UINavigationController()
    navigationController.navigationBar.isHidden = true
    
    // MARK: - Service
    let airportSearchService = AirportSearchService(
      bundle: Bundle(for: AirportSearchService.self)
    )
    
    try? airportSearchService.loadAirports()
    
    let authService = AuthService()
    let bookSearchService = BookSearchService()
    let searchHistoryService = SearchHistoryService()
    let tooltipService = TooltipService()
    
    // MARK: - Builder
    let homeBuilder = HomeBuilder()
    let loginBuilder = LoginBuilder()
    let searchBuilder = SearchBuilder(
      airportSearchService: airportSearchService,
      bookSearchService: bookSearchService,
      searchHistoryService: searchHistoryService
    )
    let wishlistBuilder = WishlistBuilder(
      tooltipService: tooltipService
    )
    let registerWishlistBuilder = RegisterWishlistBuilder()
    let wishTicketBuilder = WishTicketBuilder()
    let checkInWishTicketBuilder = CheckInWishTicketBuilder()
    let registerHistoryBuilder = RegisterHistoryBuilder()
    let registerJourneyBuilder = RegisterJourneyBuilder()
    let journeyTicketBuilder = JourneyTicketBuilder()
    let journeyBuilder = JourneyBuilder(
      tooltipService: tooltipService
    )
    let historyBuilder = HistoryBuilder()
    let detailHistoryBuilder = DetailHistoryBuilder()
    
    let coordinator = AppCoordinator(
      navigationController: navigationController,
      authService: authService,
      homeBuilder: homeBuilder,
      loginBuilder: loginBuilder,
      searchBuilder: searchBuilder,
      wishlistBuilder: wishlistBuilder,
      checkInWishTicketBuilder: checkInWishTicketBuilder,
      registerWishlistBuilder: registerWishlistBuilder,
      wishTicketBuilder: wishTicketBuilder,
      journeyTicketBuilder: journeyTicketBuilder,
      registerHistoryBuilder: registerHistoryBuilder,
      registerJourneyBuilder: registerJourneyBuilder,
      jourenyBuilder: journeyBuilder,
      historyBuilder: historyBuilder,
      detailHistoryBuilder: detailHistoryBuilder
    )
    
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    self.window = window
    self.appCoordinator = coordinator
    
    coordinator.start()
  }
}
