//
//  TooltipServiceTests.swift
//  TooltipTests
//
//  Created by 여성일 on now.
//

import XCTest
@testable import TooltipImplementation
@testable import TooltipInterface

final class TooltipServiceTests: XCTestCase {
  private var sut: TooltipService!
  private var userDefaults: UserDefaults!
  
  override func setUp() {
    super.setUp()
    userDefaults = UserDefaults(suiteName: #file)!
    userDefaults.removePersistentDomain(forName: #file)
    sut = TooltipService(userDefaults: userDefaults)
  }
  
  override func tearDown() {
    userDefaults.removePersistentDomain(forName: #file)
    userDefaults = nil
    sut = nil
    super.tearDown()
  }
  
  /*
   툴팁이 아직 표시되지 않았을 때 shouldShowTooltip이 true를 반환하는지 검증하는 테스트
   - Given: 저장된 값이 없는 TooltipKey
   - When: shouldShowTooltip 호출
   - Then: true를 반환하는지 확인합니다.
   */
  func test_shouldShowTooltip_returnsTrue_whenNotShown() {
    let result = sut.shouldShowTooltip(for: .journeyCurrentPage)
    
    XCTAssertTrue(result)
  }
  
  /*
   툴팁을 표시 완료로 기록하면 이후 shouldShowTooltip이 false를 반환하는지 검증하는 테스트
   - Given: 표시되지 않은 TooltipKey
   - When: markTooltipShown 호출 후 shouldShowTooltip 호출
   - Then: false를 반환하는지 확인합니다.
   */
  func test_markTooltipShown_makesShouldShowTooltipReturnFalse() {
    sut.markTooltipShown(for: .journeyCurrentPage)
    
    let result = sut.shouldShowTooltip(for: .journeyCurrentPage)
    
    XCTAssertFalse(result)
  }
  
  /*
   특정 TooltipKey에 대한 기록이 다른 TooltipKey에는 영향을 주지 않는지 검증하는 테스트
   - Given: 하나의 TooltipKey만 표시 완료로 기록된 상태
   - When: 다른 TooltipKey에 대해 shouldShowTooltip 호출
   - Then: true를 반환하는지 확인합니다.
   */
  func test_markTooltipShown_doesNotAffectOtherKeys() {
    sut.markTooltipShown(for: .journeyCurrentPage)
    
    let result = sut.shouldShowTooltip(for: .wishlistSwipeGuide)
    
    XCTAssertTrue(result)
  }
}
