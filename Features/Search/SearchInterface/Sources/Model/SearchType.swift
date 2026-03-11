//
//  SearchType.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

public enum SearchType {
  case book
  case departureAirport
  case arrivalAirport

  public var placeholder: String {
    switch self {
    case .book:
      return "검색어를 입력하세요"
    case .departureAirport:
      return "출발 공항 검색 (공항명/도시/코드)"
    case .arrivalAirport:
      return "도착 공항 검색 (공항명/도시/코드)"
    }
  }
}
