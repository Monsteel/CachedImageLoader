
import Foundation

public struct CacheContainer: Codable {
  let image: Data
  let etag: String?
}
