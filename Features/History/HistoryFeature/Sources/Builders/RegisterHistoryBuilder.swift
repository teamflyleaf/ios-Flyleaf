//
//  RegisterHistoryBuilder.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import UIKit
import HistoryInterface
import ReadingJourneyInterface

public final class RegisterHistoryBuilder: RegisterHistoryBuildable {
  let readingJourneyService: ReadingJourneyServicing
  
  public init(
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.readingJourneyService = readingJourneyService
  }
  
  public func build(
    onRoute: ((RegisterHistoryRoute) -> Void)?
  ) -> UIViewController {
    let viewModel = RegisterHistoryViewModel(readingJourneyService: readingJourneyService)
    
    let viewController = RegisterHistoryViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    
    return viewController
  }
}
