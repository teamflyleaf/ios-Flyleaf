//
//  SearchHistoryServiceTests.swift
//  SearchHistoryTests
//
//  Created by 여성일 on now.
//

import XCTest
@testable import SearchHistoryImplementation
@testable import SearchHistoryInterface
@testable import Core

final class SearchHistoryServiceTests: XCTestCase {
  private var sut: SearchHistoryService!
  private var userDefaults: UserDefaults!
  
  override func setUp() {
    super.setUp()
    userDefaults = UserDefaults(suiteName: #file)!
    userDefaults.removePersistentDomain(forName: #file)
    sut = SearchHistoryService(userDefaults: userDefaults, maxCount: 3)
  }
  
  override func tearDown() {
    userDefaults.removePersistentDomain(forName: #file)
    userDefaults = nil
    sut = nil
    super.tearDown()
  }
  
  /*
   저장된 값이 없을 때 빈 배열을 반환하는지 검증하는 테스트
   - Given: 아무 데이터도 저장되지 않은 상태
   - When: fetch 호출
   - Then: 빈 배열이 반환되는지 확인합니다.
   */
  func test_fetch_returnsEmptyArray_whenNoStoredValue() {
    let result = sut.fetch(type: .book)
    
    XCTAssertEqual(result, [])
  }
  
  /*
   검색어를 저장하면 최신순으로 맨 앞에 추가되는지 검증하는 테스트
   - Given: 빈 최근 검색어 상태
   - When: save 호출
   - Then: 저장된 검색어가 배열의 첫 번째 요소로 추가되는지 확인합니다.
   */
  func test_save_storesQueryAtFront() {
    sut.save("설국", type: .book)
    
    let result = sut.fetch(type: .book)
    
    XCTAssertEqual(result, ["설국"])
  }
  
  /*
   동일한 검색어를 저장하면 중복 없이 맨 앞으로 이동하는지 검증하는 테스트
   - Given: 동일한 검색어가 이미 존재하는 상태
   - When: 동일한 검색어를 다시 save 호출
   - Then: 중복 없이 맨 앞에 위치하는지 확인합니다.
   */
  func test_save_removesDuplicateAndMovesToFront() {
    sut.save("설국", type: .book)
    sut.save("데미안", type: .book)
    sut.save("설국", type: .book)
    
    let result = sut.fetch(type: .book)
    
    XCTAssertEqual(result, ["설국", "데미안"])
  }
  
  /*
   공백이 포함된 검색어를 저장할 때 trimming이 적용되는지 검증하는 테스트
   - Given: 앞뒤 공백이 포함된 검색어
   - When: save 호출
   - Then: 공백이 제거된 상태로 저장되는지 확인합니다.
   */
  func test_save_trimsWhitespace() {
    sut.save("  설국  ", type: .book)
    
    let result = sut.fetch(type: .book)
    
    XCTAssertEqual(result, ["설국"])
  }
  
  /*
   공백만 있는 검색어는 저장되지 않는지 검증하는 테스트
   - Given: 공백만 있는 문자열
   - When: save 호출
   - Then: 아무 값도 저장되지 않는지 확인합니다.
   */
  func test_save_doesNothing_whenQueryIsEmptyAfterTrimming() {
    sut.save("   ", type: .book)
    
    let result = sut.fetch(type: .book)
    
    XCTAssertEqual(result, [])
  }
  
  /*
   최대 개수를 초과하면 오래된 항목이 제거되는지 검증하는 테스트
   - Given: maxCount를 초과하는 검색어를 저장한 상태
   - When: fetch 호출
   - Then: 최신 순으로 maxCount 개수만 유지되는지 확인합니다.
   */
  func test_save_keepsOnlyMaxCountItems() {
    sut.save("A", type: .book)
    sut.save("B", type: .book)
    sut.save("C", type: .book)
    sut.save("D", type: .book) // 초과
    
    let result = sut.fetch(type: .book)
    
    XCTAssertEqual(result, ["D", "C", "B"])
  }
  
  /*
   특정 검색어를 삭제하면 해당 값만 제거되는지 검증하는 테스트
   - Given: 여러 검색어가 저장된 상태
   - When: 특정 검색어 delete 호출
   - Then: 해당 검색어만 제거되는지 확인합니다.
   */
  func test_delete_removesSpecificQuery() {
    sut.save("설국", type: .book)
    sut.save("데미안", type: .book)
    
    sut.delete("설국", type: .book)
    
    let result = sut.fetch(type: .book)
    
    XCTAssertEqual(result, ["데미안"])
  }
  
  /*
   존재하지 않는 검색어를 삭제해도 변화가 없는지 검증하는 테스트
   - Given: 저장된 검색어 목록
   - When: 존재하지 않는 검색어 delete 호출
   - Then: 기존 목록이 그대로 유지되는지 확인합니다.
   */
  func test_delete_doesNothing_whenQueryDoesNotExist() {
    sut.save("설국", type: .book)
    
    sut.delete("데미안", type: .book)
    
    let result = sut.fetch(type: .book)
    
    XCTAssertEqual(result, ["설국"])
  }
  
  /*
   전체 삭제를 수행하면 해당 타입의 데이터가 모두 제거되는지 검증하는 테스트
   - Given: 여러 검색어가 저장된 상태
   - When: deleteAll 호출
   - Then: 해당 타입의 검색어가 모두 삭제되는지 확인합니다.
   */
  func test_deleteAll_removesAllQueries() {
    sut.save("설국", type: .book)
    sut.save("데미안", type: .book)
    
    sut.deleteAll(type: .book)
    
    let result = sut.fetch(type: .book)
    
    XCTAssertEqual(result, [])
  }
  
  /*
   검색 타입별로 저장이 독립적으로 관리되는지 검증하는 테스트
   - Given: 서로 다른 SearchType에 검색어를 저장한 상태
   - When: 각각 fetch 호출
   - Then: 타입별로 독립된 결과가 반환되는지 확인합니다.
   */
  func test_storage_isSeparatedBySearchType() {
    sut.save("설국", type: .book)
    sut.save("ICN", type: .departureAirport)
    
    let bookResult = sut.fetch(type: .book)
    let airportResult = sut.fetch(type: .departureAirport)
    
    XCTAssertEqual(bookResult, ["설국"])
    XCTAssertEqual(airportResult, ["ICN"])
  }
}
