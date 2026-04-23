//
//  TermsOfServiceBuildable.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import UIKit

public protocol TermsOfServiceBuildable {
  func build(
    onRoute: @escaping (TermsOfServiceRoute) -> Void
  ) -> UIViewController
}
