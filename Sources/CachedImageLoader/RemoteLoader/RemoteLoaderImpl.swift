
import Foundation

internal final class RemoteLoaderImpl: RemoteLoader {
  internal func fetch(for url: URL, etag: String?) async throws -> RemoteLoaderResponse {
    var urlRequest = URLRequest(url: url)

    if let etag = etag {
      urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
      urlRequest.setValue(etag, forHTTPHeaderField: "If-None-Match")
    }

    let (data, response) = try await URLSession.shared.data(for: urlRequest)

    // Check if the response is HTTPURLResponse
    guard let httpResponse = response as? HTTPURLResponse else {
      return .failure(RemoteLoaderErrorFactory.httpResponseIsNotHTTPURLResponse(response))
    }

    // Check if the response is 304
    if httpResponse.statusCode == 304 { return .notModified }

    // Check if the response is 200 ..< 300
    if (200 ..< 300) ~= httpResponse.statusCode {
      let etag = httpResponse.allHeaderFields["Etag"] as? String
      return .success(image: data, etag: etag)
    }

    // If the response is not 200 ..< 300, return bad response
    return .failure(RemoteLoaderErrorFactory.badResponse(httpResponse))
  }
}
