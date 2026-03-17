//
//  AladinBookDetailResponseDTO.swift
//  Core
//
//  Created by 여성일 on 3/17/26.
//

import Foundation

struct AladinBookDetailResponseDTO: Decodable {
  let item: [AladinBookDetailItemDTO]

  func toModel() throws -> BookInfo {
    guard let first = item.first else {
      throw BookSearchError.missingBookDetail
    }
    return try first.toModel()
  }
}

struct AladinBookDetailItemDTO: Decodable {
  let title: String
  let author: String
  let cover: String
  let publisher: String
  let isbn13: String
  let subInfo: AladinBookSubInfoDTO?

  func toModel() throws -> BookInfo {
    guard let itemPage = subInfo?.itemPage else {
      throw BookSearchError.missingItemPage
    }

    return BookInfo(
      isbn13: isbn13,
      title: title,
      author: author,
      publisher: publisher,
      itemPage: itemPage,
      cover: cover
    )
  }
}

struct AladinBookSubInfoDTO: Decodable {
  let itemPage: Int?
}
