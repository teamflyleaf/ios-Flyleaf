//
//  HomeViewModelTests.swift
//  Home
//
//  Created by 여성일 on 3/11/26.
//

import XCTest
@testable import Core
@testable import HomeFeature

final class HomeViewModelTests: XCTestCase {
  /*
   독서 진행률이 정상적으로 계산되는지 검증하는 테스트

   - Given: currentPage와 전체 페이지 수(itemPage)가 있는 ReadingJourney
   - When: calculateProgress(journey:) 호출
   - Then: currentPage / itemPage 값으로 진행률이 정상 계산되는지 확인합니다.
   */
  func test_calculateProgress_normal() {
    // Mock, ViewModel 생성
    let viewModel = HomeViewModel()
    let journey = ReadingJourney.cheongjuToFukuoka
    
    let progress = viewModel.calculateProgress(journey: journey)
    
    // 테스팅
    // 계산 값의 오차범위가 0.001 이하인지 검사
    XCTAssertEqual(progress, 200.0 / 584.0, accuracy: 0.001)
  }

  /*
   모든 여행의 총 이동 거리가 정상적으로 합산되는지 검증하는 테스트

   - Given: 여러 개의 ReadingJourney가 포함된 HomeViewModel
   - When: totalDistance 프로퍼티 조회
   - Then: 각 여행의 distanceKm 값이 모두 합산된 결과가 반환되는지 확인합니다.
   */
  func test_totalDistance_sumsDistance() {
    // Mock, ViewModel 생성
    let viewModel = HomeViewModel()
    
    // 테스팅
    XCTAssertEqual(viewModel.totalDistance, 540 + 820)
  }
}

