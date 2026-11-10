//
//  Yes24BookDetailResponseDTO.swift
//  BookSearch
//
//  Created by 여성일 on 11/10/26.
//

import Core
import Foundation

public struct Yes24BookDetailResponseDTO: Decodable {
    let data: Yes24BookDetailDataDTO
}

extension Yes24BookDetailResponseDTO {
    public func toModel() throws -> BookInfo {
        guard let first = data.items.first else {
            throw BookSearchError.missingBookDetail
        }
        return try first.toModel()
    }
}

public struct Yes24BookDetailDataDTO: Decodable {
    let items: [Yes24BookDetailItemDTO]
}

public struct Yes24BookDetailItemDTO: Decodable {
    let title: String
    let author: String
    let cover: String
    let publisher: String
    let isbn13: String
    let pages: Int?
    let contentDetail: Yes24BookDetailContentDetailDTO?
}

extension Yes24BookDetailItemDTO {
    public func toModel() throws -> BookInfo {
        guard let pages else {
            throw BookSearchError.missingItemPage
        }
        
        return BookInfo(
            isbn13: isbn13,
            title: title,
            author: author,
            publisher: publisher,
            itemPage: pages,
            cover: cover,
            description: contentDetail?.bookIntroduction ?? ""
        )
    }
}
public struct Yes24BookDetailContentDetailDTO: Decodable {
    let bookIntroduction: String
}
