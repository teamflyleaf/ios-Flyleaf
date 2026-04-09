//
//  Project.swift
//  Auth
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Auth",
  targets: [
    .serviceInterface(.auth),
    .serviceImplementation(
      .auth,
      dependencies: [
        .firebaseAuth(),
        .firebaseCore()
      ]
    ),
    .serviceTesting(.auth),
    .serviceTests(.auth)
  ]
)
