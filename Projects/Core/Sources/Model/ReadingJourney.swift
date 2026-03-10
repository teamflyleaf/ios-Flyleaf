//
//  ReadingJourney.swift
//  Core
//
//  Created by 여성일 on 3/10/26.
//

import Foundation

public struct ReadingJourney: Codable, Equatable, Sendable {
  public let id: String
  public let status: ReadingJourneyStatusType

  public let departureAirport: AirportInfo 
  public let arrivalAirport: AirportInfo

  public let distanceKm: Double
  public let remainingDistanceKm: Double?

  public let book: BookInfo

  public let reason: String?

  public let startedAt: Date?
  public let finishedAt: Date?

  public let currentPage: Int?
  public let progressUpdatedAt: Date?

  public let review: String?

  public let createdAt: Date
  public let updatedAt: Date?
  public let lastUpdatedAt: Date

  public init(
    id: String,
    status: ReadingJourneyStatusType,
    departureAirport: AirportInfo,
    arrivalAirport: AirportInfo,
    distanceKm: Double,
    remainingDistanceKm: Double?,
    book: BookInfo,
    reason: String?,
    startedAt: Date?,
    finishedAt: Date?,
    currentPage: Int?,
    progressUpdatedAt: Date?,
    review: String?,
    createdAt: Date,
    updatedAt: Date?,
    lastUpdatedAt: Date
  ) {
    self.id = id
    self.status = status
    self.departureAirport = departureAirport
    self.arrivalAirport = arrivalAirport
    self.distanceKm = distanceKm
    self.remainingDistanceKm = remainingDistanceKm
    self.book = book
    self.reason = reason
    self.startedAt = startedAt
    self.finishedAt = finishedAt
    self.currentPage = currentPage
    self.progressUpdatedAt = progressUpdatedAt
    self.review = review
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.lastUpdatedAt = lastUpdatedAt
  }
}
