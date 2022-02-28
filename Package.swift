// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CumulocityCoreLibrary",
    platforms: [
		.iOS(.v13)
   	],
    products: [
        .library(
            name: "CumulocityCoreLibrary",
            targets: ["CumulocityCoreLibrary"]),
    ],
    targets: [
        .target(
            name: "CumulocityCoreLibrary",
            dependencies: []),
		.testTarget(
			name: "CumulocityCoreLibraryTests",
			dependencies: ["CumulocityCoreLibrary"])
    ]
)
