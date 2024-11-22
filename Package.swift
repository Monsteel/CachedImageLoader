// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "CachedImageLoader",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "CachedImageLoader",
      targets: ["CachedImageLoader", "CachedAsyncImage"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Monsteel/Dessert.git", from: "0.2.1"),
  ],
  targets: [
    .target(
      name: "CachedImageLoader",
      dependencies: [
        "Dessert",
      ]
    ),
    .target(
      name: "CachedAsyncImage",
      dependencies: ["CachedImageLoader"]
    ),
  ]
)
