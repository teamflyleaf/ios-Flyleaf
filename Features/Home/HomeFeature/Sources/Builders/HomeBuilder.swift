//
//  HomeBuilder.swift
//  Home
//
//  Created by 여성일 on 3/8/26.
//

import Core
import HomeInterface
import UIKit

public final class HomeBuilder: HomeBuildable {
  public init() {}

  public func build(
    onRoute: @escaping (HomeRoute) -> Void
  ) -> UIViewController {
    let readingJourneyService = FirebaseReadingJourneyService()
    let viewModel = HomeViewModel(readingJourneyService: readingJourneyService)
    let viewController = HomeViewController(viewModel: viewModel)
    
    viewController.onRoute = onRoute
    
    return viewController
  }
}
