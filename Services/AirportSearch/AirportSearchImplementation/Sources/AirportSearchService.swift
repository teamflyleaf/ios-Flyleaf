//
//  AirportSearchService.swift
//  AirportSearchImplementation
//
//  Created by 여성일 on now.
//

import AirportSearchInterface
import Core
import Foundation

/// 로컬 JSON 파일을 기반으로 공항 데이터를 로드하고 검색 기능을 제공하는 서비스입니다.
///
/// 앱 번들에 포함된 공항 데이터(`world_airports.json`)를 메모리에 로드한 후,
/// 사용자의 입력(query)에 따라 공항을 필터링합니다.
///
/// ```swift
/// let service = AirportSearchService()
/// try service.loadAirports()
/// let results = service.searchAirports(query: "seoul")
/// ```
///
/// - Note:
///   - 공항 데이터는 앱 번들 내 JSON 파일에서 로드됩니다.
///   - `loadAirports()`를 반드시 먼저 호출해야 검색이 정상 동작합니다.
///   - 검색은 `AirportInfo.searchText` 필드를 기반으로 수행됩니다.
///
/// - Important:
///   - Tuist 또는 Swift Package 환경에서는 `Bundle.main`이 아닌
///     `Bundle.module`을 사용해야 리소스를 정상적으로 찾을 수 있습니다.
///   - JSON 파일이 번들에 포함되지 않으면 `resourceNotFound` 에러가 발생합니다.
public final class AirportSearchService: AirportSearchServicing {
  private let bundle: Bundle
  private let fileName: String
  private let fileExtension: String

  private var airports: [AirportInfo] = []

  /// - Parameters:
  ///   - bundle: JSON 리소스를 로드할 번들 (기본값: `.main`)
  ///   - fileName: 공항 데이터 파일 이름 (기본값: "world_airports")
  ///   - fileExtension: 파일 확장자 (기본값: "json")
  public init(
    bundle: Bundle = .main,
    fileName: String = "world_airports",
    fileExtension: String = "json"
  ) {
    self.bundle = bundle
    self.fileName = fileName
    self.fileExtension = fileExtension
  }

  /// 번들에 포함된 JSON 파일을 읽어 공항 데이터를 메모리에 로드합니다.
  ///
  /// - Throws:
  ///   - `AirportSearchError.resourceNotFound`: JSON 파일을 찾을 수 없는 경우
  ///   - `AirportSearchError.decodeFailed`: JSON 디코딩에 실패한 경우
  ///   - 기타 파일 읽기(Data(contentsOf:)) 관련 오류
  ///
  /// - Important:
  ///   - 이 메서드는 반드시 앱 시작 시 1회 호출해야 합니다.
  ///   - 호출하지 않으면 `searchAirports`는 항상 빈 배열을 반환합니다.
  public func loadAirports() throws {
    guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
      throw AirportSearchError.resourceNotFound
    }

    let data = try Data(contentsOf: url)

    do {
      airports = try JSONDecoder().decode([AirportInfo].self, from: data)
    } catch {
      throw AirportSearchError.decodeFailed
    }
  }

  /// 입력된 검색어를 기반으로 공항 목록을 필터링합니다.
  ///
  /// - Parameter query: 사용자 입력 검색어
  /// - Returns: 검색어와 일치하는 공항 목록
  ///
  /// - Note:
  ///   - 검색어는 공백 제거 및 소문자 변환 후 비교됩니다.
  ///   - 실제 검색은 `AirportInfo.searchText` 필드를 기준으로 수행됩니다.
  ///
  /// - Important:
  ///   - 사전 로드된 `airports` 배열을 기반으로 필터링되므로
  ///     `loadAirports()` 호출 이후에만 정상 동작합니다.
  ///   - 검색어가 비어 있는 경우 빈 배열을 반환합니다.
  public func searchAirports(query: String) -> [AirportInfo] {
    let normalizedQuery = query
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .lowercased()

    guard !normalizedQuery.isEmpty else { return [] }

    return airports.filter {
      $0.searchText.contains(normalizedQuery)
    }
  }
}
