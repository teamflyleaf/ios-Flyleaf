//
//  AirportAnnotation.swift
//  Home
//
//  Created by 여성일 on 3/9/26.
//

import MapKit

/// Map에 공항 위치를 표시하기 위한 MKAnnotation 모델입니다.
///
/// `MKAnnotation`을 구현하여 지도에 표시될 공항의
/// 좌표, 공항 코드, 아이콘 타입(출발/도착)을 포함합니다.
final class AirportAnnotation: NSObject, MKAnnotation {
  let iconType: AirportIconType
  let code: String
  let coordinate: CLLocationCoordinate2D

  /// - Parameters:
  ///   - iconType: 공항 아이콘 타입 (출발 / 도착)
  ///   - code: 공항 코드 (예: CJJ, FUK)
  ///   - coordinate: 공항의 지도 좌표
  init(
    iconType: AirportIconType,
    code: String,
    coordinate: CLLocationCoordinate2D,
  ) {
    self.iconType = iconType
    self.code = code
    self.coordinate = coordinate
  }
}
