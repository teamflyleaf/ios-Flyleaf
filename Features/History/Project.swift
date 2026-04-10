//
//  Project.swift
//  History
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "History",
  targets: [
    .microFeature(
      .history,
      dependencies: [
        .service(.readingJourney, .interface),
        .service(.readingJourney, .implementation)
      ]
    ),
    .microInterface(
      .history,
      dependencies: [
        .service(.readingJourney, .interface),
      ]
    ),
    .microTests(.history),
    .microTesting(.history),
    .microExample(.history)
  ]
)
