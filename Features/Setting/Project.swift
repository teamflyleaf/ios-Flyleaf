//
//  Project.swift
//  Setting
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Setting",
  targets: [
    .microFeature(.setting),
    .microInterface(.setting),
    .microTests(.setting),
    .microTesting(.setting),
    .microExample(.setting)
  ]
)
