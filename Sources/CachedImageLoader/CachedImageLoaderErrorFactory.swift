//
//  CachedImageLoaderErrorFactory.swift
//  CachedImageLoader
//
//  Created by Tony on 10/21/24.
//

import Foundation

internal enum CachedImageLoaderErrorFactory {
  private enum Code: Int {
    case urlIsNil = 0
    case imageNotInCache = 1
  }
  
  internal static func urlIsNil() -> NSError {
    NSError(
      domain: "\(Self.self)",
      code: Code.urlIsNil.rawValue,
      userInfo: [:]
    )
  }
  
  internal static func imageNotInCache(_ url: String) -> NSError {
    NSError(
      domain: "\(Self.self)",
      code: Code.imageNotInCache.rawValue,
      userInfo: [
        "url": url
      ]
    )
  }
}
