//
//  Project.swift
//  ReadingJourney
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "ReadingJourney",
  targets: [
    .serviceInterface(.readingJourney),
    .serviceImplementation(
      .readingJourney,
      dependencies: [
        .firebaseFirestore(),
        .firebaseAuth()
      ]
    ),
    .serviceTesting(.readingJourney),
    .serviceTests(.readingJourney)
  ]
)
