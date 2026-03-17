//
//  AirportInfo.swift
//  Core
//
//  Created by 여성일 on 3/10/26.
//

import CoreLocation
import Foundation

public struct AirportInfo: Codable, Equatable, Sendable {
  public let iata: String
  
  public let airportNameEn: String
  public let airportNameKo: String
  
  public let cityNameEn: String
  public let cityNameKo: String
  
  public let countryNameKo: String
  
  public let latitude: Double
  public let longitude: Double
  
  /// 검색 최적화를 위한 필드
  public let searchText: String
  
  public init(
    iata: String,
    airportNameEn: String,
    airportNameKo: String,
    cityNameEn: String,
    cityNameKo: String,
    countryNameKo: String,
    latitude: Double,
    longitude: Double,
    searchText: String
  ) {
    self.iata = iata
    self.airportNameEn = airportNameEn
    self.airportNameKo = airportNameKo
    self.cityNameEn = cityNameEn
    self.cityNameKo = cityNameKo
    self.countryNameKo = countryNameKo
    self.latitude = latitude
    self.longitude = longitude
    self.searchText = searchText
  }
  
  public var displayName: String {
    "\(cityNameKo) (\(iata))"
  }
  
  public var coordinate: (lat: Double, lon: Double) {
    (latitude, longitude)
  }
}

extension AirportInfo {
  public static func distanceKm(
    from: AirportInfo,
    to: AirportInfo
  ) -> Int {
    
    let start = CLLocation(latitude: from.latitude, longitude: from.longitude)
    let end = CLLocation(latitude: to.latitude, longitude: to.longitude)
    
    return Int(start.distance(from: end) / 1000)
  }
}
