//
//  JourneyTicketBuilder.swift
//  Journey
//
//  Created by 여성일 on 3/19/26.
//

import Core
import UIKit
import JourneyInterface
import ReadingJourneyInterface
import ReadingJourneyImplementation

public final class JourneyTicketBuilder: JourneyTicketBuildable {
  public init() {}
  
  public func build(
    payload: JourneyPayload,
    onRoute: @escaping (JourneyTicketRoute) -> Void
  ) -> UIViewController {
    let readingJourneyService = ReadingJourneyService()
    let viewModel = JourneyTicketViewModel(
      payload: payload,
      readingJourneyService: readingJourneyService
    )
    
    let viewController = JourneyTicketViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    
    return viewController
  }
}
