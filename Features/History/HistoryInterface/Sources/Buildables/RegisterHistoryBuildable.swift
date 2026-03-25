//
//  RegisterHistoryBuildable.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import UIKit

public protocol RegisterHistoryBuildable {
  func build(
    onRoute: ((RegisterHistoryRoute) -> Void)?
  ) -> UIViewController
}
