//
//  AirportIconType.swift
//  Home
//
//  Created by 여성일 on 3/9/26.
//

import UIKit

/// AirportAnnotaion에 표시할 아이콘 유형 타입입니다.
/// 출발 공항과 도착 공항을 구분하기 위한 enum이며,
/// 각 case에 대응하는 이미지 에셋을 제공합니다.
///
/// - `departure`: 출발 공항 아이콘
/// - `arrival`: 도착 공항 아이콘
enum AirportIconType {
  /// 출발 공항 아이콘
  case departure
  /// 도착 공항 아이콘
  case arrival
  
  var image: UIImage {
    switch self {
    case .departure:
      return .takeOff
    case .arrival:
      return .landing
    }
  }
}
