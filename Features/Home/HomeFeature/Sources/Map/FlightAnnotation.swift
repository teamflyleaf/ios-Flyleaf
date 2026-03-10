//
//  FlightAnnotation.swift
//  Home
//
//  Created by 여성일 on 3/10/26.
//

import MapKit

/// Map에 비행기 위치를 표시하기 위한 커스텀 `MKAnnotation`입니다.
///
/// 출발 공항과 도착 공항 사이 경로 위에서 비행기의 위치를 나타내기 위해 사용합니다.
final class FlightAnnotation: NSObject, MKAnnotation {
  /*
   `coordinate` 속성은 MapKit이 위치 변경을 감지할 수 있도록
   `dynamic`으로 선언되어 있으며, 이를 통해 비행기 위치를 업데이트하면 지도 상에서도 위치가 갱신됩니다.
   */
  dynamic var coordinate: CLLocationCoordinate2D
  
  /// - Parameters:
  ///   - coordinate: 비행기가 표시될 좌표
  init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
  }
}
