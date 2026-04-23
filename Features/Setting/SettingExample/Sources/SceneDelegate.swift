//
//  SceneDelegate.swift
//  SettingExample
//
//  Created by 여성일 on now.
//

import UIKit
import SettingFeature

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {

    guard let windowScene = scene as? UIWindowScene else { return }
    
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = SettingRootViewController()
    window.makeKeyAndVisible()
    
    self.window = window
  }
}
