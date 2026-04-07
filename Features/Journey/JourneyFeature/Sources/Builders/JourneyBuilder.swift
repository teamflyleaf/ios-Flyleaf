//
//  JourneyBuilder.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import Core
import UIKit
import JourneyInterface
import TooltipImplementation

public final class JourneyBuilder: JourneyBuildable {
  public init() {}
  
  public func build(
    onRoute: ((JourneyRoute) -> Void)?
  ) -> UIViewController {
    let readingJourneyService = FirebaseReadingJourneyService()
    let memoService = JourneyMemoService()
    let tooltipService = TooltipService()
    let viewModel = JourneyViewModel(
      readingJourneyService: readingJourneyService,
      memoService: memoService,
      tooltipService: tooltipService
    )
    let viewController = JourneyViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    return viewController
  }
}
