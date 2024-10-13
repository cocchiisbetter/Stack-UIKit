// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StackUIKit",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "StackUIKit", targets: ["StackUIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/cocchiisbetter/Layout-UIKit.git", exact: "0.1.0")
    ],
    targets: [
        .target(
            name: "StackUIKit",
            dependencies: [
                .product(name: "LayoutUIKit", package: "Layout-UIKit")
            ]
        ),
        .testTarget(name: "StackUIKitTests", dependencies: ["StackUIKit"]),
    ]
)
