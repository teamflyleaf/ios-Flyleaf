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
        "UIUserInterfaceStyle": "Dark",
        "CFBundleDisplayName": "Flyleaf Dev",
        "ALADIN_TTB_KEY": "$(ALADIN_TTB_KEY)",
        "CFBundleShortVersionString": "$(MARKETING_VERSION)",
        "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
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
        .firebaseCore(),
        .core(),
        .designSystem(),
        .diContainer(),
        .feature(.onboarding, .feature),
        .feature(.onboarding, .interface),
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
        .feature(.setting, .feature),
        .feature(.setting, .interface),
        .service(.auth, .interface),
        .service(.auth, .implementation),
        .service(.airportSearch, .implementation),
        .lottie()
      ],
      settings: .settings(
        base: [
          "OTHER_LDFLAGS": "$(inherited) -ObjC"
        ],
        configurations: [
          .debug(
            name: "Debug",
            settings: [
              "DEVELOPMENT_TEAM": "X67DB976UU",
              "CODE_SIGN_STYLE": "Manual",
              "CODE_SIGN_IDENTITY": "Apple Development: Seongil Yeo (SP9DA93H4W)",
              "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDev",
              "TARGETED_DEVICE_FAMILY": "1",
              "MARKETING_VERSION": "1.3.0",
              "CURRENT_PROJECT_VERSION": "2"
            ],
            xcconfig: "../../Configs/DevDebug.xcconfig"
          ),
          .release(
            name: "Release",
            settings: [
              "DEVELOPMENT_TEAM": "X67DB976UU",
              "CODE_SIGN_STYLE": "Manual",
              "CODE_SIGN_IDENTITY": "Apple Distribution: Seongil Yeo (X67DB976UU)",
              "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDev",
              "TARGETED_DEVICE_FAMILY": "1",
              "MARKETING_VERSION": "1.3.0",
              "CURRENT_PROJECT_VERSION": "2"
            ],
            xcconfig: "../../Configs/DevRelease.xcconfig"
          ),
        ]
      )
    ),
    .target(
      name: "AppTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "com.yeo.flyleaf.dev.tests",
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "FlyleafDev"),
        .service(.auth, .interface),
        .service(.readingJourney, .interface)
      ]
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
        "UIUserInterfaceStyle": "Dark",
        "CFBundleDisplayName": "Flyleaf",
        "ALADIN_TTB_KEY": "$(ALADIN_TTB_KEY)",
        "CFBundleShortVersionString": "$(MARKETING_VERSION)",
        "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
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
        .firebaseCore(),
        .core(),
        .designSystem(),
        .diContainer(),
        .feature(.onboarding, .feature),
        .feature(.onboarding, .interface),
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
        .feature(.setting, .feature),
        .feature(.setting, .interface),
        .service(.auth, .interface),
        .service(.auth, .implementation),
        .service(.airportSearch, .implementation),
        .lottie()
      ],
      settings: .settings(
        base: [
          "OTHER_LDFLAGS": "$(inherited) -ObjC"
        ],
        configurations: [
          .debug(
            name: "Debug",
            settings: [
              "DEVELOPMENT_TEAM": "X67DB976UU",
              "CODE_SIGN_STYLE": "Manual",
              "CODE_SIGN_IDENTITY": "Apple Development: Seongil Yeo (SP9DA93H4W)",
              "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
              "TARGETED_DEVICE_FAMILY": "1",
              "MARKETING_VERSION": "1.3.0",
              "CURRENT_PROJECT_VERSION": "2"
            ],
            xcconfig: "../../Configs/ProdDebug.xcconfig"
          ),
          .release(
            name: "Release",
            settings: [
              "DEVELOPMENT_TEAM": "X67DB976UU",
              "CODE_SIGN_STYLE": "Manual",
              "CODE_SIGN_IDENTITY": "Apple Distribution: Seongil Yeo (X67DB976UU)",
              "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
              "TARGETED_DEVICE_FAMILY": "1",
              "MARKETING_VERSION": "1.3.0",
              "CURRENT_PROJECT_VERSION": "2"
            ],
            xcconfig: "../../Configs/ProdRelease.xcconfig"
          )
        ]
      )
    )
  ]
)
