//
//  RegisterJourneyBuilder.swift
//  Journey
//
//  Created by 여성일 on 3/19/26.
//

import Core
import JourneyInterface
import UIKit

public final class RegisterJourneyBuilder: RegisterJourneyBuildable {
  public init() {}

  public func build(
    onRoute: ((RegisterJourneyRoute) -> Void)?
  ) -> UIViewController {
    let viewModel = RegisterJourenyViewModel()
    let viewController = RegisterJourenyViewController(viewModel: viewModel)

    viewController.onRoute = onRoute
    
    return viewController
  }

}
