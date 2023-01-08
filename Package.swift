// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "ALAarambh",
  platforms: [
    .macOS(.v10_13),
    .iOS(.v11),
    .tvOS(.v11),
    .watchOS(.v4),
    .custom("Ubuntu", versionString: "22.04")
  ],
  products: [
    .executable(name: "App", targets: ["App"]),
    .library(name: "Aarambh", targets: ["Aarambh"])
  ],
  dependencies: [],
  targets: [
    .executableTarget(name: "App", dependencies: ["Aarambh"]),
    .target(name: "Aarambh", dependencies: []),
    .testTarget(name: "AarambhTests", dependencies: ["Aarambh"])
  ]
)
