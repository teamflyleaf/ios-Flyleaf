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
    .microFeature(.wishlist),
    .microInterface(.wishlist),
    .microTests(.wishlist),
    .microTesting(.wishlist),
    .microExample(.wishlist)
  ]
)
