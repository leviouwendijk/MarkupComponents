// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "MarkupComponents",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "MarkupComponents",
            targets: [
                "MarkupComponents",
            ]
        ),
        .executable(
            name: "markuptest",
            targets: [
                "MarkupComponentsTestFlows",
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/leviouwendijk/HTML.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/CSS.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/Constructors.git",
            branch: "master"
        ),

        // .package(
        //     url: "https://github.com/leviouwendijk/Assets.git",
        //     branch: "master"
        // ),

        // .package(
        //     url: "https://github.com/leviouwendijk/Primitives.git",
        //     branch: "master"
        // ),

        .package(
            url: "https://github.com/leviouwendijk/TestFlows.git",
            branch: "master"
        ),
    ],
    targets: [
        .target(
            name: "MarkupComponents",
            dependencies: [
                .product(
                    name: "HTML",
                    package: "HTML"
                ),
                .product(
                    name: "CSS",
                    package: "CSS"
                ),
                .product(
                    name: "Constructors",
                    package: "Constructors"
                ),
            ]
        ),
        .executableTarget(
            name: "MarkupComponentsTestFlows",
            dependencies: [
                "MarkupComponents",
                .product(
                    name: "Constructors",
                    package: "Constructors"
                ),
                .product(
                    name: "TestFlows",
                    package: "TestFlows"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
