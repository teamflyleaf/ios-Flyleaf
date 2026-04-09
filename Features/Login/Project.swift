//
//  Project.swift
//  Login
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Login",
  targets: [
    .microFeature(
      .login,
      dependencies: [
        .service(.auth, .interface),
        .service(.auth, .implementation)
      ]
    ),
    .microInterface(.login),
    .microTests(.login),
    .microTesting(.login),
    .microExample(.login)
  ]
)
