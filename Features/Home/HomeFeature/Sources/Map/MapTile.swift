//
//  MapTile.swift
//  Home
//
//  Created by 여성일 on 3/11/26.
//

import Foundation

/// MapKit에서 사용할 타일 지도 URL을 정의합니다.
///
/// - `darkNolabels`: CartoDB에서 제공하는 Dark Matter 스타일의 지도 타일 URL
enum MapTile {
  static let darkNolabels = "https://a.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}.png"
}
