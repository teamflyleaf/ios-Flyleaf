//
//  HistoryBuilder.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import UIKit
import HistoryInterface
import ReadingJourneyInterface

public final class HistoryBuilder: HistoryBuildable {
  let readingJourneyService: ReadingJourneyServicing
  
  public init(
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.readingJourneyService = readingJourneyService
  }
  
  public func build(
    onRoute: ((HistoryRoute) -> Void)?
  ) -> UIViewController {
    let viewModel = HistoryViewModel(
      readingJourneyService: readingJourneyService
    )
    let viewController = HistoryViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    return viewController
  }
}
