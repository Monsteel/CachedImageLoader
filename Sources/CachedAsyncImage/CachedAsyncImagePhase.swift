//
//  CachedAsyncImagePhase.swift
//  CachedImageLoader
//
//  Created by Mercen on 10/20/24.
//

import SwiftUI

public enum CachedAsyncImagePhase {
  case empty
  case success(Image)
  case failure(any Error)
  
  public var image: Image? {
    guard case let .success(image) = self else { return nil }
    return image
  }
}
