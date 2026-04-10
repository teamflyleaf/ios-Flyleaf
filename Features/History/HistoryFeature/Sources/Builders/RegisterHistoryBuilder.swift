//
//  RegisterHistoryBuilder.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import UIKit
import HistoryInterface
import ReadingJourneyImplementation

public final class RegisterHistoryBuilder: RegisterHistoryBuildable {
  public init() {}
  
  public func build(
    onRoute: ((RegisterHistoryRoute) -> Void)?
  ) -> UIViewController {
    let readingJourneyService = ReadingJourneyService()
    let viewModel = RegisterHistoryViewModel(readingJourneyService: readingJourneyService)
    
    let viewController = RegisterHistoryViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    
    return viewController
  }
}
