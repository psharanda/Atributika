// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Atributika",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(name: "Atributika", targets: ["Atributika"]),
        .library(name: "AtributikaViews", targets: ["AtributikaViews"]),
    ],
    targets: [
        .target(name: "Atributika", path: "Sources/Core"),
        .target(name: "AtributikaViews", path: "Sources/Views"),
        .testTarget(name: "AtributikaTests", dependencies: ["Atributika"]),
    ],
    swiftLanguageVersions: [.v5]
)
