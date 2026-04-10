//
//  Target+ServiceFactory.swift
//  Manifests
//
//  Created by 여성일 on 4/7/26.
//

import ProjectDescription

public extension Target {
  static func serviceImplementation(
    _ name: ServiceName,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let base = name.rawValue
    let product: Product = name == .airportSearch ? .framework : .staticFramework
    return .target(
      name: Targets.service(name, .implementation),
      destinations: .iOS,
      product: product,
      bundleId: "com.yeo.flyleaf.\(base.lowercased()).implementation",
      sources: ["\(base)Implementation/Sources/**"],
      resources: ["\(base)Implementation/Resources/**"],
      dependencies: [
        .service(name, .interface),
        .core()
      ] + dependencies
    )
  }
  
  static func serviceInterface(
    _ name: ServiceName,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let base = name.rawValue
    return .target(
      name: Targets.service(name, .interface),
      destinations: .iOS,
      product: .framework,
      bundleId: "com.yeo.flyleaf.\(base.lowercased()).interface",
      sources: ["\(base)Interface/Sources/**"],
      dependencies: [
        .core()
      ] + dependencies
    )
  }
  
  static func serviceTesting(
    _ name: ServiceName,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let base = name.rawValue
    return .target(
      name: Targets.service(name, .testing),
      destinations: .iOS,
      product: .framework,
      bundleId: "com.yeo.flyleaf.\(base.lowercased()).testing",
      sources: ["\(base)Testing/Sources/**"],
      dependencies: [
        .service(name, .interface),
        .core()
      ] + dependencies
    )
  }
  
  static func serviceTests(
    _ name: ServiceName,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let base = name.rawValue
    return .target(
      name: Targets.service(name, .tests),
      destinations: .iOS,
      product: .unitTests,
      bundleId: "com.yeo.flyleaf.\(base.lowercased()).tests",
      sources: ["\(base)Tests/Tests/**"],
      dependencies: [
        .service(name, .implementation),
        .service(name, .interface),
        .service(name, .testing)
      ] + dependencies
    )
  }
}
