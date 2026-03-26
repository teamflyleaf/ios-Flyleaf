//
//  MainTabBarController.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/11/26.
//

import UIKit

enum Tab: Int {
  case home = 0
  case journey = 1
  case wishlist = 2
  case history = 3
}

final class MainTabBarController: UITabBarController {
  init(
    homeViewController: UIViewController,
    journeyViewController: UIViewController,
    wishlistViewController: UIViewController,
    historyViewController: UIViewController
  ) {
    super.init(nibName: nil, bundle: nil)
    
    configureAppearance()
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
  // 탭바의 색상 및 스타일을 설정하는 메소드
  func configureAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    
    // 배경색
    appearance.backgroundColor = .n50
    
    // 선택 상태
    appearance.stackedLayoutAppearance.selected.iconColor = .key0
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
      .foregroundColor: UIColor.key0
    ]
    
    // 기본 상태
    appearance.stackedLayoutAppearance.normal.iconColor = .n20
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
      .foregroundColor: UIColor.n20
    ]
    
    tabBar.standardAppearance = appearance
    
    if #available(iOS 15.0, *) {
      tabBar.scrollEdgeAppearance = appearance
    }
  }
  
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
      image: "airplane",
      selectedImage: "airplane"
    )
    
    let wishlistNavigationController = makeTabNavigationController(
      rootViewController: wishlistViewController,
      title: "예약",
      image: "bookmark",
      selectedImage: "bookmark.fill"
    )
    
    let historyNavigationController = makeTabNavigationController(
      rootViewController: historyViewController,
      title: "기록",
      image: "clock",
      selectedImage: "clock.fill"
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
