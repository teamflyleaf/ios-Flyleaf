//
//  Project.swift
//  Onboarding
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Onboarding",
  targets: [
    .microFeature(.onboarding),
    .microInterface(.onboarding),
    .microTests(.onboarding),
    .microTesting(.onboarding),
    .microExample(.onboarding)
  ]
)
