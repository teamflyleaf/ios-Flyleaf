//
//  MainTabBarController.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/11/26.
//

import UIKit

final class MainTabBarController: UITabBarController {
  init(
    homeViewController: UIViewController,
    journeyViewController: UIViewController,
    wishlistViewController: UIViewController,
    historyViewController: UIViewController,
  ) {
    super.init(nibName: nil, bundle: nil)
    configureTabs(
      homeViewController: homeViewController,
      journeyViewController: journeyViewController,
      wishlistViewController: wishlistViewController,
      historyViewController: historyViewController
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private
private extension MainTabBarController {
  // 탭바에 표시될 VC를 설정하는 메소드
  func configureTabs(
    homeViewController: UIViewController,
    journeyViewController: UIViewController,
    wishlistViewController: UIViewController,
    historyViewController: UIViewController
  ) {
    let homeNavigationController = makeTabNavigationController(
      rootViewController: homeViewController,
      title: "홈",
      image: "house",
      selectedImage: "house.fill"
    )
    
    let journeyNavigationController = makeTabNavigationController(
      rootViewController: journeyViewController,
      title: "여행",
      image: "house",
      selectedImage: "house.fill"
    )
    
    let wishlistNavigationController = makeTabNavigationController(
      rootViewController: wishlistViewController,
      title: "여행",
      image: "house",
      selectedImage: "house.fill"
    )
    
    let historyNavigationController = makeTabNavigationController(
      rootViewController: historyViewController,
      title: "여행",
      image: "house",
      selectedImage: "house.fill"
    )
    
    setViewControllers(
      [
        homeNavigationController,
        journeyNavigationController,
        wishlistNavigationController,
        historyNavigationController
      ],
      animated: false
    )
  }
  
  // 탭에서 사용할 VC를 생성하는 팩토리 메소드
  func makeTabNavigationController(
    rootViewController: UIViewController,
    title: String,
    image: String,
    selectedImage: String
  ) -> UINavigationController {
    let navigationController = UINavigationController(rootViewController: rootViewController)
    navigationController.isNavigationBarHidden = true

    navigationController.tabBarItem = UITabBarItem(
      title: title,
      image: UIImage(systemName: image),
      selectedImage: UIImage(systemName: selectedImage)
    )

    return navigationController
  }
}
