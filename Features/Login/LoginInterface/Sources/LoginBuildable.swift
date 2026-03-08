//
//  LoginBuildable.swift
//  Login
//
//  Created by 여성일 on 3/8/26.
//

import UIKit

public protocol LoginBuildable {
  func build(onLoginSuccess: @escaping () -> Void) -> UIViewController
}
