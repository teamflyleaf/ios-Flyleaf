//
//  SettingBuildable.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import UIKit

public protocol SettingBuildable {
  func build(
    onRoute: @escaping (SettingRoute) -> Void
  ) -> UIViewController
}
