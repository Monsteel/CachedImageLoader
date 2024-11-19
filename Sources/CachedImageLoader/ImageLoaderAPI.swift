
import Dessert
import Foundation

public enum ImageLoaderAPI {
  case fetchImage(url: URL, activeDiskCache: Bool)
}

extension ImageLoaderAPI: Router {
  public var baseURL: URL {
    switch self {
    case let .fetchImage(url, _):
      return url
    }
  }
  
  public var path: String {
    switch self {
    case .fetchImage:
      return ""
    }
  }
  
  public var method: HttpMethod {
    switch self {
    case let .fetchImage(_, activeDiskCache):
      return .get(enableEtag: true, enableDiskCache: activeDiskCache)
    }
  }
  
  public var task: RouterTask {
    switch self {
    case .fetchImage:
      return .requestPlain
    }
  }
  
  public var headers: [String: String]? {
    switch self {
    case .fetchImage:
      return nil
    }
  }
  
}
