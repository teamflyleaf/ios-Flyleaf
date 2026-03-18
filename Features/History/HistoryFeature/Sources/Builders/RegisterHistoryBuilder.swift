//
//  RegisterHistoryBuilder.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import UIKit
import HistoryInterface

public final class RegisterHistoryBuilder: RegisterHistoryBuildable {
  public init() {}
  
  public func build(
    onTapBack: (() -> Void)?,
    onTapRegisterBookSearch: ((@escaping (BookInfo) -> Void) -> Void)?,
    onTapSelectDepartureButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onTapSelectDestinationButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onUploadCompleted: @escaping () -> Void
  ) -> UIViewController {
    let readingJourneyService = FirebaseReadingJourneyService()
    let viewModel = RegisterHistoryViewModel(readingJourneyService: readingJourneyService)
    
    let viewController = RegisterHistoryViewController(viewModel: viewModel)
    
    viewController.onTapBack = onTapBack
    viewController.onTapRegisterBookSearch = onTapRegisterBookSearch
    viewController.onTapSelectDepartureButton = onTapSelectDepartureButton
    viewController.onTapSelectDestinationButton = onTapSelectDestinationButton
    viewController.onUploadCompleted = onUploadCompleted
    return viewController
  }
}
