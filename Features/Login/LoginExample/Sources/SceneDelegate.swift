//
//  SceneDelegate.swift
//  LoginExample
//
//  Created by 여성일 on now.
//

import LoginFeature
import LoginInterface
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {

    guard let windowScene = scene as? UIWindowScene else { return }

    let window = UIWindow(windowScene: windowScene)

    let loginBuilder: LoginBuildable = LoginBuilder()

    let loginVC = loginBuilder.build {
      print("Login Success")
    }

    window.rootViewController = UINavigationController(rootViewController: loginVC)
    window.makeKeyAndVisible()

    self.window = window
  }
}
