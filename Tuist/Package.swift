// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
          "SnapKit": .framework,
          "Then": .framework
        ]
    )
#endif

let package = Package(
    name: "Flyleaf",
    dependencies: [
      .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
      .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
      .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "12.10.0")
    ]
)
