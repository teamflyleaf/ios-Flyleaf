//
//  HomeBuildable.swift
//  Home
//
//  Created by 여성일 on 3/8/26.
//

import ReadingJourneyInterface
import UIKit

public protocol HomeBuildable {
  func build(
    preloadedJourneys: [ReadingJourney],
    onRoute: @escaping (HomeRoute) -> Void
  ) -> (viewController: UIViewController, refresh: () -> Void)
}
