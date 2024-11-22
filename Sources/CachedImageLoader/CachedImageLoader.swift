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

public final class CachedImageLoader {
  private let routerManager: RouterManager<ImageLoaderAPI>

  public init(
    routerManager: RouterManager<ImageLoaderAPI> = {
      let nsCache = NSCache<NSString, NSData>()
      nsCache.countLimit = 100 // 100 images
      nsCache.totalCostLimit = 1024 * 1024 * 10 // 10MB

      return .init(
        diskCacheLoader: .init(
          path: "CachedImageLoader"
        ),
        memoryCacheLoader: .init(cache: nsCache)
      )
    }()
  ) {
    self.routerManager = routerManager
  }

  public func load(_ url: URL?, activeDiskCache: Bool = true) async throws -> Data {
    guard let url = url else { throw CachedImageLoaderErrorFactory.urlIsNil() }
    let request = ImageLoaderAPI.fetchImage(url: url, activeDiskCache: activeDiskCache)
    return try await routerManager.request(request)
  }

  public func clearCache() async throws {
    try await CacheManager.default.clear()
  }
}
