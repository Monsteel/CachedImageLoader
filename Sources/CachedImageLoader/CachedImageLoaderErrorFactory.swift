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
  }
  
  internal static func urlIsNil() -> NSError {
    NSError(
      domain: "\(Self.self)",
      code: Code.urlIsNil.rawValue,
      userInfo: [:]
    )
  }
}
