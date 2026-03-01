//
//  Project.swift
//  Manifests
//
//  Created by 여성일 on 3/1/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Targets.designSystem,
  targets: [
    .target(
      name: Targets.designSystem,
      destinations: .iOS,
      product: .framework,
      bundleId: "com.yeo.flyleaf.designsystem",
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .core(),
        .snapKit(),
        .then()
      ]
    )
  ]
)
