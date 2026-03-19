//
//  +CLLocationCoordinate2D.swift
//  DesignSystem
//
//  Created by 여성일 on 3/20/26.
//

import MapKit

public extension CLLocationCoordinate2D {
  
  /// 경도를 `-180...180` 범위로 정규화한 새로운 좌표를 반환합니다.
  /// 이 프로퍼티는 해당 값을 정상 범위로 보정하여,
  /// 지도 렌더링이나 annotation 위치 계산 시 발생할 수 있는
  /// 불연속성(discontinuity) 문제를 방지합니다.
  ///
  /// - Returns: 경도가 `-180...180` 범위로 보정된 `CLLocationCoordinate2D`
  ///
  /// - Important:
  ///   - 날짜변경선을 넘는 경로를 처리할 때 필수적으로 사용해야 합니다.
  ///   - 경로(polyline)와 annotation이 서로 다른 좌표계를 사용할 경우
  ///     위치가 어긋나는 문제가 발생할 수 있습니다.
  var normalizedLongitudeCoordinate: CLLocationCoordinate2D {
    var lng = longitude
    while lng > 180 { lng -= 360 }
    while lng < -180 { lng += 360 }
    return CLLocationCoordinate2D(latitude: latitude, longitude: lng)
  }
}
