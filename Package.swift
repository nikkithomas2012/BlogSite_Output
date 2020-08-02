// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "DamoniqueDevSite",
    products: [
        .executable(name: "DamoniqueDevSite", targets: ["DamoniqueDevSite"])
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.7.0")
    ],
    targets: [
        .target(
            name: "DamoniqueDevSite",
            dependencies: ["Publish"]
        )
    ]
)
