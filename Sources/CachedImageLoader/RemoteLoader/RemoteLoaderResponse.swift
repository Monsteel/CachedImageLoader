
import Foundation

public enum RemoteLoaderResponse {
  case success(image: Data, etag: String?)
  case notModified
  case failure(Error)
}
