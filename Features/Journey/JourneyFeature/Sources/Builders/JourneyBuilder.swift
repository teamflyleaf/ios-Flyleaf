//
//  JourneyBuilder.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import Core
import UIKit
import JourneyInterface
import TooltipInterface
import ReadingJourneyImplementation

public final class JourneyBuilder: JourneyBuildable {
  private let tooltipService: TooltipServicing
  public init(
    tooltipService: TooltipServicing
  ) {
    self.tooltipService = tooltipService
  }
  
  public func build(
    onRoute: ((JourneyRoute) -> Void)?
  ) -> UIViewController {
    let readingJourneyService = ReadingJourneyService()
    let memoService = JourneyMemoService()
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
