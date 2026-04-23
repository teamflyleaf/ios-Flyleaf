//
//  PrivacyPolicyBuildable.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import UIKit

public protocol PrivacyPolicyBuildable {
  func build(
    onRoute: @escaping (PrivacyPolicyRoute) -> Void
  ) -> UIViewController
}
