// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "ReefBuddy",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .iOSApplication(
            name: "ReefBuddy",
            targets: ["ReefBuddy"],
            bundleIdentifier: "com.reefbuddy.app",
            displayVersion: "1.0.0",
            bundleVersion: "1",
            supportedDeviceFamilies: [.pad, .phone],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "ReefBuddy",
            path: "ReefBuddy",
            resources: [
                .process("Assets.xcassets")
            ]
        )
    ]
)
