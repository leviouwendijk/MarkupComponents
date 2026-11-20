// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "MarkupComponentsTests",
    platforms: [
        .macOS(.v13),
    ],
    products: [
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
        .package(path: ".."),
    ],
    targets: [
        .executableTarget(
            name: "MarkupComponentsTestFlows",
            dependencies: [
                .product(name: "MarkupComponents", package: "MarkupComponents"),
                .product(
                    name: "Constructors",
                    package: "Constructors"
                ),
                .product(
                    name: "HTML",
                    package: "HTML"
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
