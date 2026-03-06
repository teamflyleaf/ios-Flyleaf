//
//  SceneDelegate.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/1/26.
//

import UIKit
import HomeFeature
import LoginFeature

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
    let coordinator = AppCoordinator(navigationController: navigationController)
    
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    self.window = window
    self.appCoordinator = coordinator
    
    coordinator.start()
  }
}
