//
//  SceneDelegate.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/1/26.
//

import UIKit
import HomeFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    
    guard let windowScene = scene as? UIWindowScene else { return }
    
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = HomeRootViewController()
    window.makeKeyAndVisible()
    
    self.window = window
  }
}
