
import Foundation

internal protocol RemoteLoader {
  func fetch(for url: URL, etag: String?) async throws -> RemoteLoaderResponse
}
