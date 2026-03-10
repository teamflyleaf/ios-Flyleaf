//
//  AirportInfo.swift
//  Core
//
//  Created by 여성일 on 3/10/26.
//

import Foundation

public struct AirportInfo: Codable, Equatable, Sendable {
  public let code: String
  public let latitude: Double
  public let longitude: Double

  public init(
    code: String,
    latitude: Double,
    longitude: Double
  ) {
    self.code = code
    self.latitude = latitude
    self.longitude = longitude
  }
}
