//
//  SceneDelegate.swift
//  HomeExample
//
//  Created by 여성일 on now.
//

import HomeFeature
import HomeInterface
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    
    let homeBuilder: HomeBuilder = HomeBuilder()
    
    let homeVC = homeBuilder.build()
    
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = homeVC
    window.makeKeyAndVisible()
    
    self.window = window
  }
}
