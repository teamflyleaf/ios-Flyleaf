//
//  TargetDependency+LibraryFactory.swift
//  Manifests
//
//  Created by 여성일 on 3/1/26.
//

import ProjectDescription

public extension TargetDependency {
  static func snapKit() -> TargetDependency {
    .external(name: Libraries.snapKit)
  }

  static func then() -> TargetDependency {
    .external(name: Libraries.then)
  }

  static func kingfisher() -> TargetDependency {
    .external(name: Libraries.kingfisher)
  }

  static func firebaseCore() -> TargetDependency {
    .external(name: Libraries.firebaseCore)
  }

  static func firebaseAuth() -> TargetDependency {
    .external(name: Libraries.firebaseAuth)
  }

  static func firebaseAnalytics() -> TargetDependency {
    .external(name: Libraries.firebaseAnalytics)
  }

  static func firebaseFirestore() -> TargetDependency {
    .external(name: Libraries.firebaseFirestore)
  }

  static func firebaseRemoteConfig() -> TargetDependency {
    .external(name: Libraries.firebaseRemoteConfig)
  }
}
