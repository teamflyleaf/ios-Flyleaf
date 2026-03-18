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
    let registerWishlistBuilder = RegisterWishlistBuilder()
    let wishTicketBuilder = WishTicketBuilder()
    let registerHistoryBuilder = RegisterHistoryBuilder()
    
    let coordinator = AppCoordinator(
      navigationController: navigationController,
      authService: authService,
      homeBuilder: homeBuilder,
      loginBuilder: loginBuilder,
      searchBuilder: searchBuilder,
      registerWishlistBuilder: registerWishlistBuilder,
      wishTicketBuilder: wishTicketBuilder,
      registerHistoryBuilder: registerHistoryBuilder
    )
    
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    self.window = window
    self.appCoordinator = coordinator
    
    coordinator.start()
  }
}
