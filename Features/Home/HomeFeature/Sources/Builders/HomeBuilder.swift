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
    preloadedJourneys: [ReadingJourney] = [],
    onRoute: @escaping (HomeRoute) -> Void
  ) -> (viewController: UIViewController, refresh: () -> Void) {
    let viewModel = HomeViewModel(
      readingJourneyService: readingJourneyService,
      preloadedJourneys: preloadedJourneys
    )
    let viewController = HomeViewController(viewModel: viewModel)
    viewController.onRoute = onRoute

    let refresh: () -> Void = {
      Task { await viewModel.refresh() }
    }

    return (viewController, refresh)
  }
}
