//
//  HistoryBuilder.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import UIKit
import HistoryInterface

public final class HistoryBuilder: HistoryBuildable {
  public init() {}
  
  public func build(
    onTapHistory: ((ReadingJourney) -> Void)?
  ) -> UIViewController {
    let viewModel = HistoryViewModel()
    let viewController = HistoryViewController(viewModel: viewModel)
    viewController.onTapHistory = onTapHistory
    return viewController
  }
}
