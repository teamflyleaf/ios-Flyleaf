//
//  MockLocalizedReadingJourneyError.swift
//  Journey
//
//  Created by 여성일 on 3/20/26.
//

import Foundation

enum MockReadingJourneyError: Error {
  case failed
}

enum MockLocalizedReadingJourneyError: LocalizedError {
  case fetchFailed

  var errorDescription: String? {
    switch self {
    case .fetchFailed:
      return "독서 여행을 불러오지 못했습니다."
    }
  }
}
