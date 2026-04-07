//
//  Project.swift
//  Journey
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Journey",
  targets: [
    .microFeature(
      .journey,
      dependencies: [
        .service(.tooltip, .interface),
        .service(.tooltip, .implementation)
      ]
    ),
    .microInterface(.journey),
    .microTests(.journey),
    .microTesting(.journey),
    .microExample(.journey)
  ]
)
