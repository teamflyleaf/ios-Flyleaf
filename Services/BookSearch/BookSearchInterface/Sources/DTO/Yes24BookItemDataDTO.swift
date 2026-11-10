//
//  Yes24BookItemDTO.swift
//  BookSearch
//
//  Created by 여성일 on 11/10/26.
//

import Core
import Foundation

public struct Yes24BookItemDTO: Decodable {
    let title: String
    let author: String
    let cover: String
    let publisher: String
    let isbn13: String
}

extension Yes24BookItemDTO {
    public func toModel() -> BookSearchItem {
        return BookSearchItem(
            title: title,
            author: author,
            coverURL: cover,
            publisher: publisher,
            isbn13: isbn13
        )
    }
}
