//
//  AladinBookItemDTO.swift
//  Core
//
//  Created by 여성일 on 3/12/26.
//

import Foundation

struct AladinBookItemDTO: Decodable {
  let title: String
  let author: String
  let cover: String
  let publisher: String
  let isbn13: String
}

extension AladinBookItemDTO {
  func toModel() -> BookSearchItem {
    BookSearchItem(
      title: title,
      author: author,
      coverURL: cover,
      publisher: publisher,
      isbn13: isbn13
    )
  }
}
