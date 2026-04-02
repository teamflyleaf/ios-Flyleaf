//
//  DetailHistoryBuilder.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import UIKit
import HistoryInterface


public final class DetailHistoryBuilder: DetailHistoryBuildable {
  public init() {}
  
  public func build(
    journey: ReadingJourney,
    onRoute: ((DetailHistoryRoute) -> Void)? = nil
  ) -> UIViewController {
    let readingJourneyService = FirebaseReadingJourneyService()
    let viewModel = DetailHistoryViewModel(
      journey: journey,
      readingJourneyService: readingJourneyService
    )
    let viewController = DetailHistoryViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    return viewController
  }
}
