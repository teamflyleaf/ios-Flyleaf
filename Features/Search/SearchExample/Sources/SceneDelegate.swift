//
//  SceneDelegate.swift
//  SearchExample
//
//  Created by 여성일 on now.
//

import UIKit
import SearchFeature
import SearchInterface

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {

    guard let windowScene = scene as? UIWindowScene else { return }

    let window = UIWindow(windowScene: windowScene)

    let searchBuilder: SearchBuildable = SearchBuilder()
    let searchVC = searchBuilder.build(type: .book)

    let navigationController = UINavigationController(rootViewController: searchVC)
    navigationController.isNavigationBarHidden = true

    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    self.window = window
  }
}
