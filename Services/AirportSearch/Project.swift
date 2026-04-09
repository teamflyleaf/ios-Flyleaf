//
//  Project.swift
//  AirportSearch
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "AirportSearch",
  targets: [
    .serviceInterface(.airportSearch),
    .serviceImplementation(.airportSearch),
    .serviceTesting(.airportSearch),
    .serviceTests(.airportSearch)
  ]
)
