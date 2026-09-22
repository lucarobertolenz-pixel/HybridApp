// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AnalysisEngineKit",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "AnalysisEngineKit", targets: ["AnalysisEngineKit"])
    ],
    targets: [
        .target(name: "AnalysisEngineKit"),
        .testTarget(name: "AnalysisEngineKitTests", dependencies: ["AnalysisEngineKit"]),
    ]
)
