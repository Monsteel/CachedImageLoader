
import Foundation

internal enum CacheLoaderErrorFactory {
  private enum Code: Int {
    case invalidURL = 0
    case failedToSaveDiskCache = 1
  }

  internal static func invalidURL(_ url: String) -> NSError {
    NSError(
      domain: "\(Self.self)",
      code: Code.invalidURL.rawValue,
      userInfo: [
        "url": url
      ]
    )
  }
  
  internal static func failedToSaveDiskCache(_ result: Bool) -> NSError {
    NSError(
      domain: "\(Self.self)",
      code: Code.failedToSaveDiskCache.rawValue,
      userInfo: [
        "result": result
      ]
    )
  }
}
