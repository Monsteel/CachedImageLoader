//
//  ReactorViewStore.swift
//  
//
//  Created by Tony on 2024/07/09.
//

import Foundation

extension CachedImageLoader {
  public static var shared: CachedImageLoader = .init()
}

public final class CachedImageLoader {
  private let remoteLoader: RemoteLoader
  private let diskCacheLoader: CacheLoader
  private let memoryCacheLoader: CacheLoader
  
  private init(
    remoteLoader: RemoteLoader = RemoteLoaderImpl(),
    diskCacheLoader: CacheLoader = DiskCacheLoader(),
    memoryCacheLoader: CacheLoader = MemoryCacheLoader()
  ) {
    self.remoteLoader = remoteLoader
    self.diskCacheLoader = diskCacheLoader
    self.memoryCacheLoader = memoryCacheLoader
  }
  
  public func load(_ url: URL?, activeDiskCache: Bool = true) async throws -> Data? {
    guard let url = url else { return nil }
    
    // If the image is not in memory cache, try to get it from disk cache
    var imageContainer: CacheContainer?
    
    imageContainer = try await memoryCacheLoader.get(for: url.absoluteString)
    
    if imageContainer == nil && activeDiskCache {
      imageContainer = try await diskCacheLoader.get(for: url.absoluteString)
    }

    let response = try await remoteLoader.fetch(for: url, etag: imageContainer?.etag)
    
    switch response {
    case let .success(data, etag):
      Task {
        do {
          try await memoryCacheLoader.save(
            for: url.absoluteString,
            .init(image: data, etag: etag)
          )
        }
      }

      Task {
        do {
          try await diskCacheLoader.save(
            for: url.absoluteString,
            .init(image: data, etag: etag)
          )
        }
      }

      return data
      
    case .notModified:
      return imageContainer?.image
      
    case let .failure(error):
      throw error
    }
  }
  
  public func clearCache() async {
    await diskCacheLoader.clear()
    await memoryCacheLoader.clear()
  }
}
