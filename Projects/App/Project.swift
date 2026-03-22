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
        "CFBundleDisplayName": "Flyleaf Dev",
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
      resources: [
        "Resources/Common/**",
        "Resources/Firebase/Dev/GoogleService-Info.plist"
      ],
      entitlements: .file(path: "Flyleaf.entitlements"),
      dependencies: [
        .core(),
        .designSystem(),
        .feature(.home, .feature),
        .feature(.home, .interface),
        .feature(.login, .feature),
        .feature(.login, .interface),
        .feature(.search, .feature),
        .feature(.search, .interface),
        .feature(.wishlist, .feature),
        .feature(.wishlist, .interface),
        .feature(.journey, .feature),
        .feature(.journey, .interface),
        .feature(.history, .feature),
        .feature(.history, .interface),
      ],
      settings: .settings(
        base: [
          "DEVELOPMENT_TEAM": "X67DB976UU",
          "CODE_SIGN_STYLE": "Automatic",
          "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDev"
        ],
        configurations: [
          .debug(name: "Debug", xcconfig: "../../Configs/Dev.xcconfig"),
          .release(name: "Release", xcconfig: "../../Configs/Dev.xcconfig")
        ]
      )
    ),
    
      .target(
        name: "Flyleaf",
        destinations: .iOS,
        product: .app,
        bundleId: "com.yeo.flyleaf",
        infoPlist: .extendingDefault(with: [
          "UILaunchScreen": [:],
          "CFBundleDevelopmentRegion": "ko",
          "CFBundleLocalizations": ["ko"],
          "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
          "CFBundleDisplayName": "Flyleaf",
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
        resources: [
          "Resources/Common/**",
          "Resources/Firebase/Prod/GoogleService-Info.plist"
        ],
        entitlements: .file(path: "Flyleaf.entitlements"),
        dependencies: [
          .core(),
          .designSystem(),
          .feature(.home, .feature),
          .feature(.home, .interface),
          .feature(.login, .feature),
          .feature(.login, .interface),
          .feature(.search, .feature),
          .feature(.search, .interface),
          .feature(.wishlist, .feature),
          .feature(.wishlist, .interface),
          .feature(.journey, .feature),
          .feature(.journey, .interface),
          .feature(.history, .feature),
          .feature(.history, .interface),
        ],
        settings: .settings(
          base: [
            "DEVELOPMENT_TEAM": "X67DB976UU",
            "CODE_SIGN_STYLE": "Automatic",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon"
          ],
          configurations: [
            .debug(name: "Debug", xcconfig: "../../Configs/Prod.xcconfig"),
            .release(name: "Release", xcconfig: "../../Configs/Prod.xcconfig")
          ]
        )
      )
  ]
)
