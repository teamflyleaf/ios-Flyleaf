//
//  AladinSearchResponseDTO.swift
//  Core
//
//  Created by 여성일 on 3/12/26.
//

import Foundation

public struct AladinSearchResponseDTO: Decodable {
  let totalResults: Int
  let startIndex: Int
  let itemsPerPage: Int
  let item: [AladinBookItemDTO]
}

extension AladinSearchResponseDTO {
  public func toModel() -> BookSearchPage {
    BookSearchPage(
      items: item.map { $0.toModel() },
      totalResults: totalResults,
      startIndex: startIndex,
      itemsPerPage: itemsPerPage
    )
  }
}
