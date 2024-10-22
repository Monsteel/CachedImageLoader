
import Foundation

internal final class DiskCacheLoader: CacheLoader {
  private let fm: FileManager
  private let queue: DispatchQueue

  internal init(
    fm: FileManager = .default,
    queue: DispatchQueue = DispatchQueue(label: "com.CachedImageLoader.DiskCacheLoader")
  ) {
    self.fm = fm
    self.queue = queue
  }

  internal func save(for key: String, _ value: CacheContainer) async throws -> Void {
    try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
      queue.async {
        do {
          // Convert key to URL
          guard let imageURL = URL(string: key) else {
            continuation.resume(throwing: CacheLoaderErrorFactory.invalidURL(key))
            return
          }

          // If the directory does not exits, create it
          if self.fm.fileExists(atPath: self.cachedImageLoaderDiskCachePath.path) == false {
            try self.fm.createDirectory(at: self.cachedImageLoaderDiskCachePath, withIntermediateDirectories: true, attributes: nil)
          }

          // Get local image path
          let localImagePath = self.localImageURL(imageURL).path

          // If the file exists, remove it
          if self.fm.fileExists(atPath: localImagePath) {
            try self.fm.removeItem(atPath: localImagePath)
          }

          // Convert value to data
          let data = try JSONEncoder().encode(value)

          // Save image data to local image path
          let result = self.fm.createFile(atPath: localImagePath, contents: data, attributes: nil)
          
          // Resume the continuation
          if result {
            continuation.resume()
          } else {
            continuation.resume(throwing: CacheLoaderErrorFactory.failedToSaveDiskCache(result))
          }
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }

  internal func get(for key: String) async throws -> CacheContainer? {
    try await withCheckedThrowingContinuation { continuation in
      queue.async {
        // Convert key to URL
        guard let imageURL = URL(string: key) else {
          continuation.resume(throwing: CacheLoaderErrorFactory.invalidURL(key))
          return
        }

        // Get local image path
        let localImagePath = self.localImageURL(imageURL).path

        // Get image data from local image path
        guard let data = self.fm.contents(atPath: localImagePath) else {
          continuation.resume(returning: nil)
          return
        }

        do {
          // Convert data to CacheContainer
          let value = try JSONDecoder().decode(CacheContainer.self, from: data)
          continuation.resume(returning: value)
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }

  private var cachedImageLoaderDiskCachePath: URL {
    let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
      .cachesDirectory,
      .userDomainMask,
      true
    )[0] as NSString

    let imageContainerDirectoryPath = documentDirectoryPath.appendingPathComponent("cachedImageLoader")

    return URL(fileURLWithPath: imageContainerDirectoryPath)
  }

  private func localImageURL(_ imageURL: URL) -> URL {
    let localImageURLString = cachedImageLoaderDiskCachePath
      .appendingPathComponent(imageURL.lastPathComponent)
      .appendingPathExtension("json")
      .path

    return URL(fileURLWithPath: localImageURLString)
  }
  
  internal func clear() async throws {
    try await withCheckedThrowingContinuation { continuation in
      queue.async {
        do {
          try self.fm.removeItem(at: self.cachedImageLoaderDiskCachePath)
          continuation.resume()
        } catch {
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
