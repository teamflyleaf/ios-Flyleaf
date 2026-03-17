//
//  JourneyMemo.swift
//  Core
//
//  Created by 여성일 on 3/10/26.
//

import Foundation

public struct JourneyMemo: Codable, Equatable, Sendable {
  public let id: String
  public let content: String
  public let page: Int?
  public let createdAt: Date
  public let updatedAt: Date?
  
  public init(
    id: String,
    content: String,
    page: Int?,
    createdAt: Date,
    updatedAt: Date?
  ) {
    self.id = id
    self.content = content
    self.page = page
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}
