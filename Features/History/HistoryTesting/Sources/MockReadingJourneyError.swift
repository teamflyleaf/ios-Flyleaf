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

  var errorDescription: String? {
    switch self {
    case .custom:
      return "중복된 독서 여행입니다."
    }
  }
}
