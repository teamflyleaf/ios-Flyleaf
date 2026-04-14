//
//  HomeBuilder.swift
//  Home
//
//  Created by 여성일 on 3/8/26.
//

import Core
import HomeInterface
import UIKit
import ReadingJourneyInterface

public final class HomeBuilder: HomeBuildable {
  let readingJourneyService: ReadingJourneyServicing
  
  public init(
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.readingJourneyService = readingJourneyService
  }

  public func build(
    onRoute: @escaping (HomeRoute) -> Void
  ) -> UIViewController {
    let viewModel = HomeViewModel(readingJourneyService: readingJourneyService)
    let viewController = HomeViewController(viewModel: viewModel)
    
    viewController.onRoute = onRoute
    
    return viewController
  }
}
