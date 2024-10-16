
import Foundation

internal enum CacheLoaderErrorFactory {
  private enum Code: Int {
    case invalidURL = 0
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
}
