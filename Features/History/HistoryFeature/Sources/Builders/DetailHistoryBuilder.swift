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
    let viewModel = DetailHistoryViewModel(journey: journey)
    let viewController = DetailHistoryViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    return viewController
  }
}
