//
//  BookInfo.swift
//  Core
//
//  Created by 여성일 on 3/10/26.
//

import Foundation

public struct BookInfo: Codable, Equatable, Sendable {
  public let isbn13: String
  public let title: String
  public let author: String
  public let publisher: String
  public let itemPage: Int
  public let cover: String
  public let description: String

  public init(
    isbn13: String,
    title: String,
    author: String,
    publisher: String,
    itemPage: Int,
    cover: String,
    description: String
  ) {
    self.isbn13 = isbn13
    self.title = title
    self.author = author
    self.publisher = publisher
    self.itemPage = itemPage
    self.cover = cover
    self.description = description
  }
}
