//
//  SceneDelegate.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/1/26.
//

import Core
import HomeFeature
import LoginFeature
import UIKit
import SearchFeature
import WishlistFeature
import HistoryFeature
import JourneyFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  var appCoordinator: AppCoordinator?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    
    guard let windowScene = scene as? UIWindowScene else { return }
    
    let navigationController = UINavigationController()
    navigationController.navigationBar.isHidden = true
    
    let authService = FirebaseAuthService()
    let homeBuilder = HomeBuilder()
    let loginBuilder = LoginBuilder()
    let searchBuilder = SearchBuilder()
    let wishlistBuilder = WishlistBuilder()
    let registerWishlistBuilder = RegisterWishlistBuilder()
    let wishTicketBuilder = WishTicketBuilder()
    let checkInWishTicketBuilder = CheckInWishTicketBuilder()
    let registerHistoryBuilder = RegisterHistoryBuilder()
    let registerJourneyBuilder = RegisterJourneyBuilder()
    let journeyTicketBuilder = JourneyTicketBuilder()
    let journeyBuilder = JourneyBuilder()
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
