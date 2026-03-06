//
//  Project.swift
//  Manifests
//
//  Created by 여성일 on 3/1/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Targets.core,
  targets: [
    .target(
      name: Targets.core,
      destinations: .iOS,
      product: .framework,
      bundleId: "com.yeo.flyleaf.core",
      sources: ["Sources/**"],
      dependencies: [
        .firebaseAuth(),
        .firebaseCore()
      ]
    )
  ]
)

