//
//  MapTile.swift
//  Home
//
//  Created by 여성일 on 3/11/26.
//

import Core
import Foundation

/// MapKit에서 사용할 타일 지도 URL을 정의합니다.
///
/// CARTO가 basemaps.cartocdn.com에 API 키 없는 요청을 제한하면서
/// 키 없이 요청하면 타일에 "API KEY REQUIRED" 워터마크가 찍혀 내려온다.
/// 쿼리 파라미터로 발급받은 키를 함께 전달해야 정상 타일을 받을 수 있다.
///
/// - `darkNolabels`: CartoDB에서 제공하는 Dark Matter 스타일의 지도 타일 URL
enum MapTile {
  static var darkNolabels: String {
    "https://a.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}.png?key=\(APIKey.carto)"
  }

  static var lightNolabels: String {
    "https://a.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png?key=\(APIKey.carto)"
  }
}
