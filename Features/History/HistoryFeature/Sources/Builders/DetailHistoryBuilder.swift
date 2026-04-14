//
//  DetailHistoryBuilder.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import UIKit
import HistoryInterface
import ReadingJourneyInterface

public final class DetailHistoryBuilder: DetailHistoryBuildable {
  let readingJourneyService: ReadingJourneyServicing
  
  public init(
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.readingJourneyService = readingJourneyService
  }
  
  public func build(
    journey: ReadingJourney,
    onRoute: ((DetailHistoryRoute) -> Void)? = nil
  ) -> UIViewController {
    let viewModel = DetailHistoryViewModel(
      journey: journey,
      readingJourneyService: readingJourneyService
    )
    let viewController = DetailHistoryViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    return viewController
  }
}
