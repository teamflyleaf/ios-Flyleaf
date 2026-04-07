//
//  Project.swift
//  Tooltip
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Tooltip",
  targets: [
    .serviceInterface(.tooltip),
    .serviceImplementation(.tooltip),
    .serviceTesting(.tooltip),
    .serviceTests(.tooltip)
  ]
)
