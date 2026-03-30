//
//  CachedMapTileOverlay.swift
//  Home
//
//  Created by 여성일 on 3/29/26.
//

import MapKit

final class CachedMapTileOverlay: MKTileOverlay {
  private let session: URLSession
  
  override init(urlTemplate: String?) {
    let configuration = URLSessionConfiguration.default
    // App에서 설정한 shared 그대로 사용
    configuration.urlCache = URLCache.shared
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    self.session = URLSession(configuration: configuration)
    super.init(urlTemplate: urlTemplate)
  }
  
  override func loadTile(
    at path: MKTileOverlayPath,
    result: @escaping (Data?, Error?) -> Void
  ) {
    let request = URLRequest(url: url(forTilePath: path))
    session.dataTask(with: request) { data, _, error in
      result(data, error)
    }.resume()
  }
}
