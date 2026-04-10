//
//  HistoryBuilder.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import UIKit
import HistoryInterface
import ReadingJourneyImplementation

public final class HistoryBuilder: HistoryBuildable {
  public init() {}
  
  public func build(
    onRoute: ((HistoryRoute) -> Void)?
  ) -> UIViewController {
    let readingJourneyService = ReadingJourneyService()
    let viewModel = HistoryViewModel(
      readingJourneyService: readingJourneyService
    )
    let viewController = HistoryViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    return viewController
  }
}
