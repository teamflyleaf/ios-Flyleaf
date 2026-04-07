//
//  SearchHistoryService.swift
//  SearchHistoryImplementation
//
//  Created by 여성일 on now.
//

import Core
import Foundation
import SearchHistoryInterface

/// `UserDefaults`를 이용해 검색 타입별 최근 검색어를 저장하고 관리하는 서비스입니다.
///
/// 검색어는 `SearchType`에 따라 별도의 키로 분리 저장되며,
/// 동일한 검색어는 중복 없이 최신순으로 정렬됩니다.
///
/// ```swift
/// let service = SearchHistoryService()
/// service.save("설국", type: .book)
/// let recentBooks = service.fetch(type: .book)
/// ```
///
/// - Note:
///   - 최근 검색어는 `SearchType`별로 독립적으로 관리됩니다.
///   - 동일한 검색어를 다시 저장하면 기존 항목은 제거되고 최상단으로 이동합니다.
///   - 저장 개수는 `maxCount`를 초과하지 않도록 자동으로 제한됩니다.
public final class SearchHistoryService: SearchHistoryServicing {
  private let userDefaults: UserDefaults
  private let maxCount: Int
  
  public init(
    userDefaults: UserDefaults = .standard,
    maxCount: Int = 10
  ) {
    self.userDefaults = userDefaults
    self.maxCount = maxCount
  }
  
  /// 특정 검색 타입에 해당하는 최근 검색어 목록을 조회합니다.
  ///
  /// - Parameter type: 조회할 검색 타입
  /// - Returns: 저장된 최근 검색어 배열
  ///
  /// - Note:
  ///   - 저장된 값이 없으면 빈 배열을 반환합니다.
  ///   - 반환 순서는 최신 검색어가 앞에 오도록 유지됩니다.
  public func fetch(type: SearchType) -> [String] {
    userDefaults.stringArray(forKey: type.recentSearchKey) ?? []
  }
  
  /// 검색어를 최근 검색어 목록에 저장합니다.
  ///
  /// - Parameters:
  ///   - query: 저장할 검색어
  ///   - type: 저장할 검색 타입
  ///
  /// - Important:
  ///   - 앞뒤 공백 및 줄바꿈 문자는 제거한 뒤 저장합니다.
  ///   - 빈 문자열은 저장하지 않습니다.
  ///   - 동일한 검색어가 이미 존재하면 기존 항목을 제거한 뒤 최상단에 다시 추가합니다.
  ///   - 저장 후 전체 개수가 `maxCount`를 초과하면 오래된 항목부터 제거됩니다.
  public func save(_ query: String, type: SearchType) {
    let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedQuery.isEmpty else { return }
    
    var items = fetch(type: type)
    
    items.removeAll { $0 == trimmedQuery }
    items.insert(trimmedQuery, at: 0)
    
    if items.count > maxCount {
      items = Array(items.prefix(maxCount))
    }
    
    userDefaults.set(items, forKey: type.recentSearchKey)
  }
  
  /// 특정 검색어를 최근 검색어 목록에서 삭제합니다.
  ///
  /// - Parameters:
  ///   - query: 삭제할 검색어
  ///   - type: 삭제 대상 검색 타입
  ///
  /// - Note:
  ///   - 동일한 문자열과 일치하는 항목만 제거합니다.
  ///   - 검색어가 존재하지 않으면 아무 동작도 하지 않습니다.
  public func delete(_ query: String, type: SearchType) {
    var items = fetch(type: type)
    items.removeAll { $0 == query }
    userDefaults.set(items, forKey: type.recentSearchKey)
  }
  
  /// 특정 검색 타입에 해당하는 최근 검색어를 모두 삭제합니다.
  ///
  /// - Parameter type: 전체 삭제할 검색 타입
  ///
  /// - Note:
  ///   - 해당 타입의 저장 키 자체를 `UserDefaults`에서 제거합니다.
  public func deleteAll(type: SearchType) {
    userDefaults.removeObject(forKey: type.recentSearchKey)
  }
}
