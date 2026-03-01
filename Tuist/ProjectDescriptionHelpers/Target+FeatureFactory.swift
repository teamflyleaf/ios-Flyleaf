//
//  Target+FeatureFactory.swift
//  Manifests
//
//  Created by 여성일 on 3/1/26.
//

import ProjectDescription

public extension Target {
  static func microFeature(
    _ name: FeatureName,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let base = name.rawValue
    return .target(
      name: Targets.feature(name, .feature),
      destinations: .iOS,
      product: .framework,
      bundleId: "com.yeo.flyleaf.\(base.lowercased()).feature",
      sources: ["\(base)Feature/Sources/**"],
      resources: ["\(base)Feature/Resources/**"],
      dependencies: [
        .feature(name, .interface),
        .core(),
        .designSystem(),
        .snapKit(),
        .then()
      ] + dependencies
    )
  }
  
  static func microInterface(
    _ name: FeatureName,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let base = name.rawValue
    return .target(
      name: Targets.feature(name, .interface),
      destinations: .iOS,
      product: .framework,
      bundleId: "com.yeo.flyleaf.\(base.lowercased()).interface",
      sources: ["\(base)Interface/Sources/**"],
      dependencies: [
        .core()
      ] + dependencies
    )
  }
  
  static func microTesting(
    _ name: FeatureName,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let base = name.rawValue
    return .target(
      name: Targets.feature(name, .testing),
      destinations: .iOS,
      product: .framework,
      bundleId: "com.yeo.flyleaf.\(base.lowercased()).testing",
      sources: ["\(base)Testing/Sources/**"],
      dependencies: [
        .feature(name, .interface),
        .core()
      ] + dependencies
    )
  }
  
  static func microTests(
    _ name: FeatureName,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let base = name.rawValue
    return .target(
      name: Targets.feature(name, .tests),
      destinations: .iOS,
      product: .unitTests,
      bundleId: "com.yeo.flyleaf.\(base.lowercased()).tests",
      sources: ["\(base)Tests/Tests/**"],
      dependencies: [
        .feature(name, .feature),
        .feature(name, .interface),
        .feature(name, .testing)
      ] + dependencies
    )
  }
  
  static func microExample(
    _ name: FeatureName,
    dependencies: [TargetDependency] = []
  ) -> Target {
    let base = name.rawValue
    return .target(
      name: Targets.feature(name, .example),
      destinations: .iOS,
      product: .app,
      bundleId: "com.yeo.flyleaf.\(base.lowercased()).example",
      infoPlist: .extendingDefault(with: [
        "UILaunchScreen": [:],
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleLocalizations": ["ko"],
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "UIApplicationSceneManifest": [
          "UIApplicationSupportsMultipleScenes": false,
          "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
              [
                "UISceneConfigurationName": "Default Configuration",
                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
              ]
            ]
          ]
        ]
      ]),
      sources: ["\(base)Example/Sources/**"],
      resources: ["\(base)Example/Resources/**"],
      dependencies: [
        .feature(name, .feature),
        .feature(name, .interface),
      ] + dependencies,
      settings: .settings(
        base: [
          "DEVELOPMENT_TEAM": "X67DB976UU",
          "CODE_SIGN_STYLE": "Automatic"
        ]
      )
    )
  }
}
