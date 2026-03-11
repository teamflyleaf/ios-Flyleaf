//
//  Targets.swift
//  Manifests
//
//  Created by 여성일 on 3/1/26.
//

// MARK: - MicoroFeature Module
public enum FeatureName: String, CaseIterable {
  case home = "Home"
  case login = "Login"
  case onboarding = "Onboarding"
  case search = "Search"
}

public enum MicroModule: String {
  case feature = "Feature"
  case interface = "Interface"
  case testing = "Testing"
  case tests = "Tests"
  case example = "Example"
}

// MARK: - Targets
public enum Targets {
  public static let core = "Core"
  public static let designSystem = "DesignSystem"
  
  public static func feature(
    _ feature: FeatureName,
    _ module: MicroModule
  ) -> String {
    "\(feature.rawValue)\(module.rawValue)"
  }
}
