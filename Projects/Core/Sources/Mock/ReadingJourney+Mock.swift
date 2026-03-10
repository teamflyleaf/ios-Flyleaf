//
//  ReadingJourney+Mock.swift
//  Core
//
//  Created by 여성일 on 3/10/26.
//

import Foundation

public extension ReadingJourney {
  static let cheongjuToFukuoka = ReadingJourney(
    id: "journey1",
    status: .reading,
    departureAirport: AirportInfo(
      code: "CJJ",
      latitude: 36.7170,
      longitude: 127.4991
    ),
    arrivalAirport: AirportInfo(
      code: "FUK",
      latitude: 33.5859,
      longitude: 130.4510
    ),
    distanceKm: 540,
    remainingDistanceKm: nil,
    book: BookInfo(
      isbn: "8966262281",
      isbn13: "9788966262281",
      title: "클린 코드",
      author: "로버트 C. 마틴",
      publisher: "인사이트",
      description: "코드 품질에 대한 고전",
      itemPage: 584,
      cover: nil
    ),
    reason: nil,
    startedAt: Date(),
    finishedAt: nil,
    currentPage: 200,
    progressUpdatedAt: nil,
    review: nil,
    createdAt: Date(),
    updatedAt: nil,
    lastUpdatedAt: Date()
  )
  
  static let busanToShanghai = ReadingJourney(
    id: "journey2",
    status: .reading,
    departureAirport: AirportInfo(
      code: "PUS",
      latitude: 35.1796,
      longitude: 129.0756
    ),
    arrivalAirport: AirportInfo(
      code: "PVG",
      latitude: 31.1443,
      longitude: 121.8083
    ),
    distanceKm: 820,
    remainingDistanceKm: nil,
    book: BookInfo(
      isbn: "8998139767",
      isbn13: "9788998139766",
      title: "객체지향의 사실과 오해",
      author: "조영호",
      publisher: "위키북스",
      description: "객체지향 개념 설명",
      itemPage: 324,
      cover: nil
    ),
    reason: nil,
    startedAt: Date(),
    finishedAt: nil,
    currentPage: 80,
    progressUpdatedAt: nil,
    review: nil,
    createdAt: Date(),
    updatedAt: nil,
    lastUpdatedAt: Date()
  )
  
  static let mockList: [ReadingJourney] = [
    .cheongjuToFukuoka,
    .busanToShanghai
  ]
}
