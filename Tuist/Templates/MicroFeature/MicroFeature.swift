//
//  MicroFeature.swift
//  Manifests
//
//  Created by 여성일 on 3/1/26.
//

import ProjectDescription

let template = Template(
  description: "MicroFeature scaffold (Feature/Interface/Testing/Tests/Example)",
  attributes: [
    .required("name"), // Home, Login
    .required("case")  // home, login (FeatureName enum case)
  ],
  items: [
    .file(
      path: "Features/{{ name }}/Project.swift",
      templatePath: "Project.stencil"
    ),
    .file(
      path: "Features/{{ name }}/{{ name }}Interface/Sources/{{ name }}InterfacePlaceholder.swift",
      templatePath: "InterfacePlaceholder.stencil"
    ),
    .file(
      path: "Features/{{ name }}/{{ name }}Feature/Sources/{{ name }}RootViewController.swift",
      templatePath: "RootViewController.stencil"
    ),
    .file(
      path: "Features/{{ name }}/{{ name }}Testing/Sources/{{ name }}TestingPlaceholder.swift",
      templatePath: "TestingPlaceholder.stencil"
    ),
    .file(
      path: "Features/{{ name }}/{{ name }}Tests/Tests/{{ name }}FeatureTests.swift",
      templatePath: "Tests.stencil"
    ),
    .file(
      path: "Features/{{ name }}/{{ name }}Example/Sources/AppDelegate.swift",
      templatePath: "ExampleAppDelegate.stencil"
    ),
    .file(
      path: "Features/{{ name }}/{{ name }}Example/Sources/SceneDelegate.swift",
      templatePath: "SceneDelegate.stencil"
    )
  ]
)
