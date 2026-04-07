//
//  Service.swift
//  Manifests
//
//  Created by 여성일 on 4/7/26.
//

import ProjectDescription

let template = Template(
  description: "Service scaffold (Interface/Implementation/Testing/Tests)",
  attributes: [
    .required("name"), // BookSearch, SearchHistory
    .required("case")  // bookSearch, searchHistory
  ],
  items: [
    .file(
      path: "Services/{{ name }}/Project.swift",
      templatePath: "Project.stencil"
    ),
    .file(
      path: "Services/{{ name }}/{{ name }}Interface/Sources/{{ name }}Servicing.swift",
      templatePath: "InterfacePlaceholder.stencil"
    ),
    .file(
      path: "Services/{{ name }}/{{ name }}Implementation/Sources/{{ name }}Service.swift",
      templatePath: "ImplementationPlaceholder.stencil"
    ),
    .file(
      path: "Services/{{ name }}/{{ name }}Testing/Sources/Mock{{ name }}Service.swift",
      templatePath: "TestingPlaceholder.stencil"
    ),
    .file(
      path: "Services/{{ name }}/{{ name }}Tests/Tests/{{ name }}ServiceTests.swift",
      templatePath: "Tests.stencil"
    )
  ]
)
