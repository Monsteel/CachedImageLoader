//
//  ReactorViewStore.swift
//  
//
//  Created by Tony on 2024/07/09.
//

import Dessert
import Foundation
import os

extension CachedImageLoader {
  public static var `default`: CachedImageLoader = .init()
}

public actor CachedImageLoader: Sendable {

  private let diskCacheLoader: DiskCacheLoader
  private let memoryCacheLoader: MemoryCacheLoader

  private lazy var routerManager = RouterManager<ImageLoaderAPI>.init(
    diskCacheLoader: self.diskCacheLoader,
    memoryCacheLoader: self.memoryCacheLoader
  )

  private lazy var cacheManager = CacheManager(
    memoryCacheLoader: self.memoryCacheLoader,
    diskCacheLoader: self.diskCacheLoader
  )

  public init(
    diskCacheLoader: DiskCacheLoader = .init(
      totalCostLimit: 1024 * 1024 * 10, // 10MB
      path: "CachedImageLoader"
    ),
    memoryCacheLoader: MemoryCacheLoader = {
      let nsCache = NSCache<NSString, NSData>()
      nsCache.countLimit = 100 // 100 images
      nsCache.totalCostLimit = 1024 * 1024 * 10 // 10MB

      return .init(cache: nsCache)
    }()
  ) {
    self.diskCacheLoader = diskCacheLoader
    self.memoryCacheLoader = memoryCacheLoader
  }

  public func load(_ url: URL?, activeDiskCache: Bool = true) async throws -> Data {
    guard let url = url else { throw CachedImageLoaderErrorFactory.urlIsNil() }
    let request = ImageLoaderAPI.fetchImage(url: url, activeDiskCache: activeDiskCache)
    return try await routerManager.request(request)
  }

  public func clearCache() async throws {
    try await cacheManager.clear()
  }
}
