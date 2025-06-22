// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "uniColor",
    platforms: [.iOS(.v15), .macOS(.v15), .tvOS(.v15), .watchOS(.v8), .visionOS(.v1)],
    products: [.library(name: "uniColor", targets: ["uniColor"])],
    targets: [
        .target(name: "uniColor", dependencies: []),
    ]
)
