//
//  SceneDelegate.swift
//  HistoryExample
//
//  Created by 여성일 on now.
//

import UIKit
import HistoryFeature
import HistoryInterface

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {

    guard let windowScene = scene as? UIWindowScene else { return }
    
    let window = UIWindow(windowScene: windowScene)
    let viewModel = RegisterHistoryViewModel()
    let registerHistoryBuilder: RegisterHistoryBuildable = RegisterHistoryBuilder()
    let registerHistoryVC = registerHistoryBuilder.build()
    window.rootViewController = registerHistoryVC
    window.makeKeyAndVisible()
    
    self.window = window
  }
}
