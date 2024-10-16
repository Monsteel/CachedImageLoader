
import Foundation

internal enum RemoteLoaderErrorFactory {
  private enum Code: Int {
    case httpResponseIsNotHTTPURLResponse = 0
    case badResponse = 1
  }

  internal static func httpResponseIsNotHTTPURLResponse(_ urlResponse: URLResponse) -> NSError {
    NSError(
      domain: "\(Self.self)",
      code: Code.httpResponseIsNotHTTPURLResponse.rawValue,
      userInfo: [
        "urlResponse": urlResponse
      ]
    )
  }

  internal static func badResponse(_ urlResponse: URLResponse) -> NSError {
    NSError(
      domain: "\(Self.self)",
      code: Code.badResponse.rawValue,
      userInfo: [
        "urlResponse": urlResponse
      ]
    )
  }
}
