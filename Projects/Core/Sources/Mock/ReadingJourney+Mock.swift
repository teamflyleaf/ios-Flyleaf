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
    departureAirport: .cheongju,
    arrivalAirport: .fukuoka,
    distanceKm: 540,
    remainingDistanceKm: nil,
    book: BookInfo(
      isbn13: "9788966262281",
      title: "클린 코드",
      author: "로버트 C. 마틴",
      publisher: "인사이트",
      itemPage: 584,
      cover: ""
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
    departureAirport: .busan,
    arrivalAirport: .shanghai,
    distanceKm: 820,
    remainingDistanceKm: nil,
    book: BookInfo(
      isbn13: "9788998139766",
      title: "객체지향의 사실과 오해",
      author: "조영호",
      publisher: "위키북스",
      itemPage: 324,
      cover: ""
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
