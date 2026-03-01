//
//  TargetDependency+ModuleFactory.swift
//  Manifests
//
//  Created by 여성일 on 3/1/26.
//

import ProjectDescription

public extension TargetDependency {
  static func core() -> TargetDependency {
    .project(target: Targets.core, path: .relativeToRoot("Projects/Core"))
  }
  
  static func designSystem() -> TargetDependency {
    .project(target: Targets.designSystem, path: .relativeToRoot("Projects/DesignSystem"))
  }
  
  static func feature(
    _ name: FeatureName,
    _ module: MicroModule
  ) -> TargetDependency {
    .project(
      target: Targets.feature(name, module),
      path: .relativeToRoot("Features/\(name.rawValue)")
    )
  }
}
