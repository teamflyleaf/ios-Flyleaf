//
//  DetailHistoryBuildable.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import UIKit
import ReadingJourneyInterface

public protocol DetailHistoryBuildable {
  func build(
    journey: ReadingJourney,
    onRoute: ((DetailHistoryRoute) -> Void)?
  ) -> UIViewController
}
