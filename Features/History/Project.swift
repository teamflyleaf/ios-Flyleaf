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
    .microFeature(.history),
    .microInterface(.history),
    .microTests(.history),
    .microTesting(.history),
    .microExample(.history)
  ]
)
