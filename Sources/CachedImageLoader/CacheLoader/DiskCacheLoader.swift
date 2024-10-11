
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
          
          // Get local image path
          let localImagePath = self.localImageURL(imageURL).path
          
          // Convert value to data
          let data = try JSONEncoder().encode(value)
          
          // Save image data to local image path
          self.fm.createFile(atPath: localImagePath, contents: data, attributes: nil)
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
  
  private func localImageURL(_ imageURL: URL) -> URL {
    // Get document directory path
    let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
      .cachesDirectory,
      .userDomainMask,
      true
    )[0] as NSString
    return URL(fileURLWithPath: documentDirectoryPath.appendingPathComponent("\(imageURL.lastPathComponent)"))
  }
  
  internal func clear() async {
    await withCheckedContinuation { continuation in
      queue.async {
        // Get document directory path
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(
          .cachesDirectory,
          .userDomainMask,
          true
        )[0] as NSString
        
        // Get all files in document directory
        guard let files = try? self.fm.contentsOfDirectory(atPath: documentDirectoryPath as String) else { return }
        
        // Remove all files in document directory
        for file in files {
          try? self.fm.removeItem(atPath: documentDirectoryPath.appendingPathComponent(file))
        }

        continuation.resume()
      }
    }
  }
}
