//
//  TargetDependency+LibraryFactory.swift
//  Manifests
//
//  Created by 여성일 on 3/1/26.
//

import ProjectDescription

public extension TargetDependency {
  static func snapKit() -> TargetDependency {
    .external(name: Libraries.snapKit)
  }
  
  static func then() -> TargetDependency {
    .external(name: Libraries.then)
  }
}
