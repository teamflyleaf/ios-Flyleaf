//
//  Project.swift
//  SearchHistory
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "SearchHistory",
  targets: [
    .serviceInterface(.searchHistory),
    .serviceImplementation(.searchHistory),
    .serviceTesting(.searchHistory),
    .serviceTests(.searchHistory)
  ]
)
