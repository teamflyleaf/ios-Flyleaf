//
//  HomeBuilder.swift
//  Home
//
//  Created by 여성일 on 3/8/26.
//

import HomeInterface
import UIKit

public final class HomeBuilder: HomeBuildable {
  public init() {}
  
  public func build() -> UIViewController {
    let viewModel = HomeViewModel()
    let viewController = HomeViewController(viewModel: viewModel)
    return viewController
  }
}
