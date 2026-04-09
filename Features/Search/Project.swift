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
    .microFeature(
      .search,
      dependencies: [
        .kingfisher(),
        .service(.searchHistory, .interface),
        .service(.searchHistory, .implementation),
        .service(.airportSearch, .interface),
        .service(.airportSearch, .implementation),
        .service(.bookSearch, .interface),
        .service(.bookSearch, .implementation)
      ]
    ),
    .microInterface(.search),
    .microTests(.search),
    .microTesting(.search),
    .microExample(.search)
  ]
)
