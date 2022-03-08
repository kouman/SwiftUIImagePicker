// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIImagePicker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "SwiftUIImagePicker",
            targets: ["SwiftUIImagePicker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUIImagePicker",
            dependencies: [],
            resources: [.process("Resources")]),
        .testTarget(
            name: "SwiftUIImagePickerTests",
            dependencies: ["SwiftUIImagePicker"]),
    ]
)
