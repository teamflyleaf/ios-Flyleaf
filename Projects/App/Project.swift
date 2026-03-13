//
//  Project.swift
//  Manifests
//
//  Created by 여성일 on 3/1/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "App",
  targets: [
    .target(
      name: "FlyleafDev",
      destinations: .iOS,
      product: .app,
      bundleId: "com.yeo.flyleaf.dev",
      infoPlist: .extendingDefault(with: [
        "UILaunchScreen": [:],
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleLocalizations": ["ko"],
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "ALADIN_TTB_KEY": "$(ALADIN_TTB_KEY)",
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
        ],
      ]),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      entitlements: .file(path: "Flyleaf.entitlements"),
      dependencies: [
        .core(),
        .designSystem(),
        .feature(.home, .feature),
        .feature(.home, .interface),
        .feature(.login, .feature),
        .feature(.login, .interface),
        .feature(.search, .feature),
        .feature(.search, .interface)
      ],
      settings: .settings(
        base: [
          "DEVELOPMENT_TEAM": "X67DB976UU",
          "CODE_SIGN_STYLE": "Automatic",
        ],
        configurations: [
          .debug(name: "Debug", xcconfig: "../../Configs/Secrets.xcconfig"),
          .release(name: "Release", xcconfig: "../../Configs/Secrets.xcconfig")
        ]
      )
    )
  ]
)
