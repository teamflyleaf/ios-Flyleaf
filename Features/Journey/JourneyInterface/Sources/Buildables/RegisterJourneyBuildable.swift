//
//  RegisterJourneyBuildable.swift
//  Journey
//
//  Created by 여성일 on 3/19/26.
//

import Core
import UIKit

public protocol RegisterJourneyBuildable {
  func build(
    onRoute: ((RegisterJourneyRoute) -> Void)?
  ) -> UIViewController
}
