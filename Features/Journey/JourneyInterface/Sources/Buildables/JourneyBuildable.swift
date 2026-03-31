//
//  JourneyBuildable.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import Core
import UIKit

public protocol JourneyBuildable {
  func build(
    onRoute: ((JourneyRoute) -> Void)?
  ) -> UIViewController
}
