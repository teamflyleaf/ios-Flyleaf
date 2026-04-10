//
//  JourneyTicketBuildable.swift
//  Journey
//
//  Created by 여성일 on 3/19/26.
//

import Core
import UIKit
import ReadingJourneyInterface

public protocol JourneyTicketBuildable {
  func build(
    payload: JourneyPayload,
    onRoute: @escaping (JourneyTicketRoute) -> Void
  ) -> UIViewController
}
