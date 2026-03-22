//
//  JourneyBuilder.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import Core
import UIKit
import JourneyInterface

public final class JourneyBuilder: JourneyBuildable {
  public init() {}
  
  public func build(
  ) -> UIViewController {
    let readingJourneyService = FirebaseReadingJourneyService()
    let memoService = JourneyMemoService()
    let viewModel = JourneyViewModel(
      readingJourneyService: readingJourneyService,
      memoService: memoService
    )
    let viewController = JourneyViewController(viewModel: viewModel)
    
    return viewController
  }
}
