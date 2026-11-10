//
//  Yed24SearchResponseDTO.swift
//  BookSearch
//
//  Created by 여성일 on 11/10/26.
//

import Foundation

public struct Yes24SearchResponseDTO: Decodable {
    let data: Yes24SearchDataDTO
}

extension Yes24SearchResponseDTO {
    public func toModel() -> BookSearchPage {
        return BookSearchPage(
            items: data.items.map { $0.toModel() },
            totalResults: data.totalCount,
            startIndex: data.currentPage,
            itemsPerPage: data.pageSize
        )
    }
}

public struct Yes24SearchDataDTO: Decodable {
    let items: [Yes24BookItemDTO]
    let currentPage: Int
    let pageSize: Int
    let totalCount: Int
}
