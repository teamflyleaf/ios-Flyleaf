//
//  SceneDelegate.swift
//  SearchExample
//
//  Created by 여성일 on now.
//

import UIKit
import SearchFeature

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {

    guard let windowScene = scene as? UIWindowScene else { return }
    
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = SearchRootViewController()
    window.makeKeyAndVisible()
    
    self.window = window
  }
}
