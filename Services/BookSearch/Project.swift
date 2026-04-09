//
//  Project.swift
//  BookSearch
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "BookSearch",
  targets: [
    .serviceInterface(.bookSearch),
    .serviceImplementation(.bookSearch),
    .serviceTesting(.bookSearch),
    .serviceTests(.bookSearch)
  ]
)
