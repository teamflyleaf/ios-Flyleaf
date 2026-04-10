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
        .service(.tooltip, .implementation),
        .service(.readingJourney, .interface),
        .service(.readingJourney, .implementation)
      ]
    ),
    .microInterface(
      .journey,
      dependencies: [
        .service(.readingJourney, .interface),
      ]
    ),
    .microTests(.journey),
    .microTesting(.journey),
    .microExample(.journey)
  ]
)
