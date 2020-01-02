// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Transitions",
  platforms: [
    .macOS(.v10_13),
    .iOS(.v10),
    .tvOS(.v10),
    .watchOS(.v2)
  ],
  products: [
    // Products define the executables and libraries produced by a package, and make them visible to other packages.
    .library(
    name: "Transitions",
    targets: ["Transitions+Core",
              "Transitions+Elements",
              "Transitions+RequestBuilder",
              "Transitions+DataProvider",
              "Transitions+Task",
              "Transitions+TaskFactory",
              "Transitions+CommonUtils",
              "Transitions+HAL+Elements",
              "Transitions+HAL+Models"]),

    .library(
      name: "Transitions+Core",
      targets: ["Transitions+Core"]),

    .library(
      name: "Transitions+Elements",
      targets: [ "Transitions+Elements"]),

    .library(
      name: "Transitions+RequestBuilder",
      targets: ["Transitions+RequestBuilder"]),

    .library(
      name: "Transitions+URLStrategy",
      targets: ["Transitions+URLStrategy"]),

    // Support

    .library(
      name: "Transitions+Task",
      targets: ["Transitions+Task"]),

    .library(
      name: "Transitions+DataProvider",
      targets: [ "Transitions+DataProvider"]),

    .library(
      name: "Transitions+TaskFactory",
      targets: [ "Transitions+TaskFactory"]),

    .library(
      name: "Transitions+CommonUtils",
      targets: ["Transitions+CommonUtils"]),

    // MARK: HAL

    .library(
      name: "Transitions+HAL",
      targets: ["Transitions+HAL+Models", "Transitions+HAL+Elements"]),


    .library(
      name: "Transitions+HAL+Elements",
      targets: [ "Transitions+HAL+Elements"]),


    .library(
      name: "Transitions+HAL+Models",
      targets: ["Transitions+HAL+Models"])

  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages which this package depends on.
    .target(
      name: "Transitions+Core"),

    .target(
      name: "Transitions+CommonUtils"),

    .target(
      name: "Transitions+HAL+Models", dependencies: ["Transitions+CommonUtils"]),

//    .testTarget(
//      name: "TransitionsCoreTests",
//      dependencies: ["Transitions+Core"]),
    
    .target(
      name: "Transitions+RequestBuilder",
      dependencies: ["Transitions+Core", "Transitions+CommonUtils"]),

    .target(
      name: "Transitions+URLStrategy",
      dependencies: ["Transitions+HAL+Models"]),

    .target(
      name: "Transitions+Task",
      dependencies: ["Transitions+Core"]),

    .target(
      name: "Transitions+DataProvider",
      dependencies: ["Transitions+Core"]),

    .target(
      name: "Transitions+Elements",
      dependencies: ["Transitions+Core", "Transitions+RequestBuilder", "Transitions+CommonUtils"]),

    .target(
      name: "Transitions+HAL+Elements",
      dependencies: ["Transitions+HAL+Models", "Transitions+RequestBuilder", "Transitions+URLStrategy"]),

    .target(
      name: "Transitions+TaskFactory",
      dependencies: ["Transitions+Task", "Transitions+DataProvider"]),

  ]
)
