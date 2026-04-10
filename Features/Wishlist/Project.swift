//
//  Project.swift
//  Wishlist
//
//  Created by 여성일 on now.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Wishlist",
  targets: [
    .microFeature(
      .wishlist,
      dependencies: [
        .service(.tooltip, .interface),
        .service(.tooltip, .implementation),
        .service(.readingJourney, .interface),
        .service(.readingJourney, .implementation)
      ]
    ),
    .microInterface(
      .wishlist,
      dependencies: [
        .service(.readingJourney, .interface),
      ]
    ),
    .microTests(.wishlist),
    .microTesting(.wishlist),
    .microExample(.wishlist)
  ]
)
