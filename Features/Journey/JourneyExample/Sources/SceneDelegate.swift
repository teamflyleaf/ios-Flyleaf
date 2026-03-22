//
//  SceneDelegate.swift
//  JourneyExample
//
//  Created by 여성일 on now.
//

import UIKit
import JourneyFeature

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {

    guard let windowScene = scene as? UIWindowScene else { return }
    
    let rootVC = JourneyRootViewController()
    let navigationController = UINavigationController(rootViewController: rootVC)
    navigationController.isNavigationBarHidden = false

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    self.window = window
  }
}
