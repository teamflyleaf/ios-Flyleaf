//
//  BookSearchItem.swift
//  Core
//
//  Created by 여성일 on 3/12/26.
//

import Foundation

public struct BookSearchItem: Equatable, Sendable {
  public let title: String
  public let author: String
  public let coverURL: String
  public let publisher: String
  public let isbn13: String

  public init(
    title: String,
    author: String,
    coverURL: String,
    publisher: String,
    isbn13: String
  ) {
    self.title = title
    self.author = author
    self.coverURL = coverURL
    self.publisher = publisher
    self.isbn13 = isbn13
  }
}
