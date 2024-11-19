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
  public static var shared: CachedImageLoader = .init()
}

public final class CachedImageLoader {
  private let routerManager: RouterManager<ImageLoaderAPI>

  private init(
    routerManager: RouterManager<ImageLoaderAPI> = .init()
  ) {
    self.routerManager = routerManager
  }

  public func load(_ url: URL?, activeDiskCache: Bool = true) async throws -> Data {
    guard let url = url else { throw CachedImageLoaderErrorFactory.urlIsNil() }
    let request = ImageLoaderAPI.fetchImage(url: url, activeDiskCache: activeDiskCache)
    return try await routerManager.request(request)
  }

  public func clearCache() async throws {
    try await CacheManager.shared.clear()
  }
}
