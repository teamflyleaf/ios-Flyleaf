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

  public func build(onTapAddButton: @escaping () -> Void) -> UIViewController {
    let viewModel = HomeViewModel()
    let viewController = HomeViewController(viewModel: viewModel)
    viewController.onTapAddButton = onTapAddButton
    return viewController
  }
}
