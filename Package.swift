// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Scaffold",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "Scaffold", targets: ["Scaffold"]),
    ],
    targets: [
        .target(name: "Scaffold"),
    ]
)
