//
//  Project.swift
//  Manifests
//
//  Created by 여성일 on 3/1/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Home",
  targets: [
    .microFeature(
      .home,
      dependencies: [
        .service(.readingJourney, .interface),
        .service(.readingJourney, .implementation)
      ]
    ),
    .microInterface(
      .home,
      dependencies: [
        .service(.readingJourney, .interface),
      ]
    ),
    .microTests(.home),
    .microTesting(.home),
    .microExample(.home)
  ]
)
