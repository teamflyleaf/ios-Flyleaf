//
//  JourneyBuilder.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import Core
import UIKit
import JourneyInterface
import ReadingJourneyInterface
import TooltipInterface

public final class JourneyBuilder: JourneyBuildable {
  private let journeyMemoService: JourneyMemoServicing
  private let readingJourneyService: ReadingJourneyServicing
  private let tooltipService: TooltipServicing

  public init(
    journeyMemoService: JourneyMemoServicing,
    readingJourneyService: ReadingJourneyServicing,
    tooltipService: TooltipServicing
  ) {
    self.journeyMemoService = journeyMemoService
    self.readingJourneyService = readingJourneyService
    self.tooltipService = tooltipService
  }
  
  public func build(
    onRoute: ((JourneyRoute) -> Void)?
  ) -> UIViewController {
    let viewModel = JourneyViewModel(
      readingJourneyService: readingJourneyService,
      memoService: journeyMemoService,
      tooltipService: tooltipService
    )
    let viewController = JourneyViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    return viewController
  }
}
