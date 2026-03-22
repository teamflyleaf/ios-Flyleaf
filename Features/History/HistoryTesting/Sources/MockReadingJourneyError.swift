//
//  MockReadingJourenyError.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Foundation

enum MockReadingJourneyError: Error {
  case failed
}

enum MockLocalizedReadingJourneyError: LocalizedError {
  case custom
  case fetchFinishedFailed
  case deleteFinishedFailed

  var errorDescription: String? {
    switch self {
    case .custom:
      return "중복된 독서 여행입니다."
    case .fetchFinishedFailed:
      return "기록 목록을 불러오지 못했습니다."
    case .deleteFinishedFailed:
      return "기록 삭제에 실패했습니다."
    }
  }
}
