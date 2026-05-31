//
//  SplashLoadingStepTests.swift
//  App
//
//  Created by 여성일 on 5/31/26.
//

import XCTest
@testable import FlyleafDev

final class SplashLoadingStepTests: XCTestCase {

  /*
   checkingAuth 단계의 displayText가 올바른지 검증하는 테스트

   - Given: SplashLoadingStep.checkingAuth
   - When: displayText 조회
   - Then: "로그인 정보를 확인하고 있어요" 문자열이 반환되는지 확인합니다.
   */
  func test_displayText_checkingAuth_returnsExpectedString() {
    XCTAssertEqual(SplashLoadingStep.checkingAuth.displayText, "로그인 정보를 확인하고 있어요")
  }
}
