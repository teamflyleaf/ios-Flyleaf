//
//  JourneyTicketBuildable.swift
//  Journey
//
//  Created by 여성일 on 3/19/26.
//

import Core
import UIKit

public protocol JourneyTicketBuildable {
  func build(
    payload: JourneyPayload,
    onTapBack: @escaping () -> Void,
    onUploadCompleted: @escaping () -> Void
  ) -> UIViewController
}
