//
//  ReadingJourneyError.swift
//  Core
//
//  Created by 여성일 on 3/17/26.
//

import Foundation

public enum ReadingJourneyError: LocalizedError {
  case unauthenticated
  case duplicateJourney
  case invalidSnapshot
  case invalidDocument
  case invalidStatus
  case unknown
  
  public var errorDescription: String? {
    switch self {
    case .unauthenticated:
      return "로그인이 필요합니다."
    case .duplicateJourney:
      return "같은 노선의 독서 여행이 이미 존재합니다."
    case .invalidSnapshot:
      return "여행 데이터를 저장하지 못했습니다."
    case .invalidDocument:
      return "독서 여행 데이터를 읽는 중 오류가 발생했습니다."
    case .invalidStatus:
      return "삭제할 수 없는 여행 상태입니다."
    case .unknown:
      return "알 수 없는 오류가 발생했습니다."
    }
  }
}
