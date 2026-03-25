//
//  HistoryBuildable.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import UIKit

public protocol HistoryBuildable {
  func build(
    onRoute: ((HistoryRoute) -> Void)?
  ) -> UIViewController
}
