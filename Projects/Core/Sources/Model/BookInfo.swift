//
//  BookInfo.swift
//  Core
//
//  Created by 여성일 on 3/10/26.
//

import Foundation

public struct BookInfo: Codable, Equatable, Sendable {
  public let isbn: String
  public let isbn13: String
  public let title: String
  public let author: String
  public let publisher: String
  public let description: String
  public let itemPage: Int
  public let cover: String?

  public init(
    isbn: String,
    isbn13: String,
    title: String,
    author: String,
    publisher: String,
    description: String,
    itemPage: Int,
    cover: String?
  ) {
    self.isbn = isbn
    self.isbn13 = isbn13
    self.title = title
    self.author = author
    self.publisher = publisher
    self.description = description
    self.itemPage = itemPage
    self.cover = cover
  }
}
