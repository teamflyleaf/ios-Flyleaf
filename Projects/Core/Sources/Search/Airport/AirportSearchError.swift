//
//  AirportSearchError.swift
//  Core
//
//  Created by 여성일 on 3/15/26.
//

import Foundation

public enum AirportSearchError: LocalizedError {
  case resourceNotFound
  case decodeFailed

  public var errorDescription: String? {
    switch self {
    case .resourceNotFound:
      return "공항 데이터를 찾을 수 없습니다."
    case .decodeFailed:
      return "공항 데이터를 불러오는 데 실패했습니다."
    }
  }
}
