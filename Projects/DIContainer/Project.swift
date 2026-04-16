//
//  Project.swift
//  Manifests
//
//  Created by 여성일 on 4/16/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Targets.diContainer,
  targets: [
    .target(
      name: Targets.diContainer,
      destinations: .iOS,
      product: .staticFramework,
      bundleId: "com.yeo.flyleaf.diContainer",
      sources: ["Sources/**"],
      dependencies: [
        .core()
      ]
    )
  ]
)

