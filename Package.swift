// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Atributika",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v2),
    ],
    products: [
        .library(name: "Atributika", targets: ["Atributika"]),
        .library(name: "AtributikaViews", targets: ["AtributikaViews"]),
        .library(name: "AtributikaMarkdown", targets: ["AtributikaMarkdown"])
    ],
    dependencies: [
            .package(url: "https://github.com/apple/swift-markdown.git", branch:"main")
        ],
    targets: [
        .target(name: "Atributika", path: "Sources/Core"),
        .target(name: "AtributikaViews", path: "Sources/Views"),
        .target(
            name: "AtributikaMarkdown",
            dependencies: [
                "Atributika",
                .product(name: "Markdown", package: "swift-markdown")
            ],
            path: "Sources/Markdown"
        ),
        .testTarget(name: "AtributikaTests", dependencies: ["Atributika"])
    ],
    swiftLanguageVersions: [.v5]
)
