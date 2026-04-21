//
//  OpenSourceBuildable.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import UIKit

public protocol OpenSourceBuildable {
  func build(
    onRoute: @escaping (OpenSourceRoute) -> Void
  ) -> UIViewController
}

