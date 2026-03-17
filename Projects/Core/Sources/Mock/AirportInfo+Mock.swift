//
//  AirportInfo+Mock.swift
//  Core
//
//  Created by 여성일 on 3/15/26.
//

import Foundation

public extension AirportInfo {

  static let cheongju = AirportInfo(
    iata: "CJJ",
    airportNameEn: "Cheongju International Airport",
    airportNameKo: "청주 국제공항",
    cityNameEn: "Cheongju",
    cityNameKo: "청주",
    countryNameKo: "대한민국",
    latitude: 36.7170,
    longitude: 127.4991,
    searchText: "청주 cheongju cjj"
  )

  static let fukuoka = AirportInfo(
    iata: "FUK",
    airportNameEn: "Fukuoka Airport",
    airportNameKo: "후쿠오카 공항",
    cityNameEn: "Fukuoka",
    cityNameKo: "후쿠오카",
    countryNameKo: "일본",
    latitude: 33.5859,
    longitude: 130.4510,
    searchText: "후쿠오카 fukuoka fuk"
  )

  static let busan = AirportInfo(
    iata: "PUS",
    airportNameEn: "Gimhae International Airport",
    airportNameKo: "김해 국제공항",
    cityNameEn: "Busan",
    cityNameKo: "부산",
    countryNameKo: "대한민국",
    latitude: 35.1796,
    longitude: 129.0756,
    searchText: "부산 busan pus"
  )

  static let shanghai = AirportInfo(
    iata: "PVG",
    airportNameEn: "Shanghai Pudong International Airport",
    airportNameKo: "상하이 푸동 국제공항",
    cityNameEn: "Shanghai",
    cityNameKo: "상하이",
    countryNameKo: "중국",
    latitude: 31.1443,
    longitude: 121.8083,
    searchText: "상하이 shanghai pvg"
  )
}
