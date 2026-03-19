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
    onTapBack: (() -> Void)?,
    onTapRegisterBookSearch: ((@escaping (BookInfo) -> Void) -> Void)?,
    onTapSelectDepartureButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onTapSelectDestinationButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onTapCreateTicket: ((BookInfo, AirportInfo, AirportInfo, Date, Int) -> Void)?
  ) -> UIViewController {
    let viewModel = RegisterJourenyViewModel()
    let viewController = RegisterJourenyViewController(viewModel: viewModel)

    viewController.onTapBack = onTapBack
    viewController.onTapRegisterBookSearch = onTapRegisterBookSearch
    viewController.onTapSelectDepartureButton = onTapSelectDepartureButton
    viewController.onTapSelectDestinationButton = onTapSelectDestinationButton
    viewController.onTapCreateTicket = onTapCreateTicket
    
    return viewController
  }

}
