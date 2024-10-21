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
  dependencies: [],
  targets: [
    .target(
      name: "CachedImageLoader",
      dependencies: []
    ),
    .target(
      name: "CachedAsyncImage",
      dependencies: ["CachedImageLoader"]
    ),
  ]
)
