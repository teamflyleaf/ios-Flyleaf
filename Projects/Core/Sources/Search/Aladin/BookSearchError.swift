//
//  BookSearchError.swift
//  Core
//
//  Created by 여성일 on 3/12/26.
//

import Foundation

public enum BookSearchError: LocalizedError {
  case invalidURL
  case invalidResponse
  case httpError(statusCode: Int)

  public var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "잘못된 검색 요청입니다."
    case .invalidResponse:
      return "응답을 처리할 수 없습니다."
    case .httpError(let statusCode):
      return "서버 오류가 발생했습니다. (\(statusCode))"
    }
  }
}
