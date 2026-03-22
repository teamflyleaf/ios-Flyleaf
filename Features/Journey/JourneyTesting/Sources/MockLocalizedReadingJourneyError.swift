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

enum MockLocalizedJourneyMemoError: LocalizedError {
  case fetchFailed
  case saveFailed
  case updateFailed
  case deleteFailed
  
  var errorDescription: String? {
    switch self {
    case .fetchFailed:
      return "메모를 불러오지 못했습니다."
    case .saveFailed:
      return "메모 저장에 실패했습니다."
    case .updateFailed:
      return "메모 수정에 실패했습니다."
    case .deleteFailed:
      return "메모 삭제에 실패했습니다."
    }
  }
}
