//
//  Project.swift
//  Search
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Search",
  targets: [
    .microFeature(.search),
    .microInterface(.search),
    .microTests(.search),
    .microTesting(.search),
    .microExample(.search)
  ]
)
