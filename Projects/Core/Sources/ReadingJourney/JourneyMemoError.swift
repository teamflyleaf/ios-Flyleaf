//
//  JourneyMemoError.swift
//  Core
//
//  Created by 여성일 on 3/22/26.
//

import Foundation

public enum JourneyMemoError: LocalizedError {
  case unauthenticated
  
  public var errorDescription: String? {
    switch self {
    case .unauthenticated:
      return "로그인이 필요합니다."
    }
  }
}
