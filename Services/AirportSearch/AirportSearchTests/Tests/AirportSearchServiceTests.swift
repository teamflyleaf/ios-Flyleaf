//
//  AirportSearchServiceTests.swift
//  AirportSearchTests
//
//  Created by 여성일 on now.
//

import XCTest
@testable import AirportSearchImplementation
@testable import AirportSearchInterface

final class AirportSearchServiceTests: XCTestCase {
  private var sut: AirportSearchService!
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  /*
   공항 JSON 리소스를 정상적으로 로드한 뒤 검색 결과를 반환하는지 검증하는 테스트
   - Given: 구현 모듈 번들에 world_airports.json 이 포함된 상태
   - When: loadAirports 호출 후 searchAirports 호출
   - Then: 검색어와 일치하는 공항 목록이 반환되는지 확인합니다.
   */
  func test_loadAirports_success_thenSearchReturnsMatchingAirports() throws {
    sut = AirportSearchService(
      bundle: Bundle(for: AirportSearchService.self)
    )
    
    try sut.loadAirports()
    let results = sut.searchAirports(query: "icn")
    
    XCTAssertFalse(results.isEmpty)
  }
  
  /*
   loadAirports를 호출하지 않은 상태에서는 검색 결과가 빈 배열인지 검증하는 테스트
   - Given: 공항 데이터를 아직 로드하지 않은 AirportSearchService
   - When: searchAirports 호출
   - Then: 빈 배열이 반환되는지 확인합니다.
   */
  func test_searchAirports_returnsEmptyArray_whenAirportsNotLoaded() {
    sut = AirportSearchService(
      bundle: Bundle(for: AirportSearchService.self)
    )
    
    let results = sut.searchAirports(query: "icn")
    
    XCTAssertEqual(results, [])
  }
  
  /*
   검색어가 비어 있을 때 빈 배열을 반환하는지 검증하는 테스트
   - Given: 공항 데이터를 로드한 상태
   - When: 빈 문자열로 searchAirports 호출
   - Then: 빈 배열이 반환되는지 확인합니다.
   */
  func test_searchAirports_returnsEmptyArray_whenQueryIsEmpty() throws {
    sut = AirportSearchService(
      bundle: Bundle(for: AirportSearchService.self)
    )
    
    try sut.loadAirports()
    let results = sut.searchAirports(query: "")
    
    XCTAssertEqual(results, [])
  }
  
  /*
   검색어가 공백만 포함할 때 빈 배열을 반환하는지 검증하는 테스트
   - Given: 공항 데이터를 로드한 상태
   - When: 공백 문자열로 searchAirports 호출
   - Then: 빈 배열이 반환되는지 확인합니다.
   */
  func test_searchAirports_returnsEmptyArray_whenQueryContainsOnlyWhitespace() throws {
    sut = AirportSearchService(
      bundle: Bundle(for: AirportSearchService.self)
    )
    
    try sut.loadAirports()
    let results = sut.searchAirports(query: "   ")
    
    XCTAssertEqual(results, [])
  }
  
  /*
   검색어 앞뒤 공백을 제거한 뒤 검색하는지 검증하는 테스트
   - Given: 공항 데이터를 로드한 상태
   - When: 앞뒤 공백이 포함된 검색어로 searchAirports 호출
   - Then: 공백 제거 후 정상 검색되는지 확인합니다.
   */
  func test_searchAirports_trimsWhitespaceBeforeSearching() throws {
    sut = AirportSearchService(
      bundle: Bundle(for: AirportSearchService.self)
    )
    
    try sut.loadAirports()
    
    let plainResults = sut.searchAirports(query: "icn")
    let trimmedResults = sut.searchAirports(query: "  icn  ")
    
    XCTAssertEqual(trimmedResults, plainResults)
  }
  
  /*
   검색어를 소문자로 변환한 뒤 검색하는지 검증하는 테스트
   - Given: 공항 데이터를 로드한 상태
   - When: 대문자가 포함된 검색어로 searchAirports 호출
   - Then: 소문자 검색과 동일한 결과를 반환하는지 확인합니다.
   */
  func test_searchAirports_lowercasesQueryBeforeSearching() throws {
    sut = AirportSearchService(
      bundle: Bundle(for: AirportSearchService.self)
    )
    
    try sut.loadAirports()
    
    let lowercasedResults = sut.searchAirports(query: "icn")
    let uppercasedResults = sut.searchAirports(query: "ICN")
    
    XCTAssertEqual(uppercasedResults, lowercasedResults)
  }
  
  /*
   존재하지 않는 파일 이름으로 초기화했을 때 resourceNotFound 에러를 던지는지 검증하는 테스트
   - Given: 존재하지 않는 JSON 파일 이름으로 초기화된 AirportSearchService
   - When: loadAirports 호출
   - Then: AirportSearchError.resourceNotFound를 던지는지 확인합니다.
   */
  func test_loadAirports_throwsResourceNotFound_whenFileDoesNotExist() {
    sut = AirportSearchService(
      bundle: Bundle(for: AirportSearchService.self),
      fileName: "missing_airports_file",
      fileExtension: "json"
    )
    
    XCTAssertThrowsError(try sut.loadAirports()) { error in
      XCTAssertEqual(error as? AirportSearchError, .resourceNotFound)
    }
  }
}
