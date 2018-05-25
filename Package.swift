// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "EnrichedText",
    products: [
        .library(
            name: "EnrichedText",
            targets: ["EnrichedText"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "EnrichedText",
            dependencies: [],
            path: "Source"),
    ]
)
