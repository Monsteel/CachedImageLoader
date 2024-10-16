
import Foundation

internal final class MemoryCacheLoader: CacheLoader {
  private let cache: NSCache<NSString, NSData>
  private let queue: DispatchQueue

  internal init(
    cache: NSCache<NSString, NSData> = NSCache<NSString, NSData>(),
    queue: DispatchQueue = DispatchQueue(label: "CachedImageLoader.MemoryCacheLoader")
  ) {
    self.cache = cache
    self.queue = queue
  }

  internal func save(for key: String, _ value: CacheContainer) async throws {
    try await withCheckedThrowingContinuation { continuation in
      queue.async {
        do {
          // Convert value to data
          let data = try JSONEncoder().encode(value)
          // Save image data to cache
          self.cache.setObject(NSData(data: data), forKey: NSString(string: key))
          continuation.resume()
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }

  internal func get(for key: String) async throws -> CacheContainer? {
    try await withCheckedThrowingContinuation { continuation in
      queue.async {
        if let data = self.cache.object(forKey: NSString(string: key)) as Data? {
          do {
            // Convert data to CacheContainer
            let value = try JSONDecoder().decode(CacheContainer.self, from: data)
            continuation.resume(returning: value)
          } catch {
            continuation.resume(throwing: error)
          }
        } else {
          continuation.resume(returning: nil)
        }
      }
    }
  }

  internal func clear() async throws {
    try await withCheckedThrowingContinuation { continuation in
      queue.async {
        self.cache.removeAllObjects()
        continuation.resume()
      }
    }
  }
}
