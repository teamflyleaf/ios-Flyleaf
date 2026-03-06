//
//  Coordinator.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/6/26.
//

import UIKit

protocol Coordinator: AnyObject {
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get }
  
  func start()
}

extension Coordinator {
  func childDidFinish(_ coordinator: Coordinator) {
    for (index, child) in childCoordinators.enumerated() {
      if child === coordinator {
        childCoordinators.remove(at: index)
        break
      }
    }
  }
  
  func pop(animated: Bool) {
    navigationController.popViewController(animated: animated)
  }
}
