//
//  DetailHistoryViewModelTests.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import XCTest
@testable import Core
@testable import HistoryFeature

final class DetailHistoryViewModelTests: XCTestCase {
  /*
   초기화 시 전달된 journey를 그대로 보관하는지 검증하는 테스트
   - Given: ReadingJourney 샘플 데이터
   - When: DetailHistoryViewModel을 생성
   - Then: viewModel이 전달받은 journey를 그대로 가지고 있는지 확인합니다.
   */
  func test_init_storesJourney() {
    let journey = makeFinishedJourney()
    
    let sut = DetailHistoryViewModel(journey: journey)
    
    XCTAssertEqual(sut.journey, journey)
  }
}

// MARK: - Helper
private extension DetailHistoryViewModelTests {
  func makeFinishedJourney() -> ReadingJourney {
    ReadingJourney(
      id: "journey-id",
      status: .finished,
      departureAirport: makeDepartureAirport(),
      arrivalAirport: makeArrivalAirport(),
      distanceKm: 540,
      remainingDistanceKm: 0,
      book: makeBookInfo(),
      reason: nil,
      startedAt: Date(timeIntervalSince1970: 1_700_000_000),
      finishedAt: Date(timeIntervalSince1970: 1_700_000_500),
      currentPage: 320,
      progressUpdatedAt: Date(timeIntervalSince1970: 1_700_000_500),
      review: "정말 좋았던 책입니다.",
      createdAt: Date(timeIntervalSince1970: 1_700_000_000),
      updatedAt: Date(timeIntervalSince1970: 1_700_000_500),
      lastUpdatedAt: Date(timeIntervalSince1970: 1_700_000_500)
    )
  }
  
  func makeBookInfo() -> BookInfo {
    BookInfo(
      isbn13: "9788937460616",
      title: "테스트 도서",
      author: "테스트 작가",
      publisher: "테스트 출판사",
      itemPage: 320,
      cover: "https://example.com/cover.jpg",
      description: "test"
    )
  }
  
  func makeDepartureAirport() -> AirportInfo {
    AirportInfo(
      iata: "ICN",
      airportNameEn: "Incheon International Airport",
      airportNameKo: "인천국제공항",
      cityNameEn: "Seoul",
      cityNameKo: "서울",
      countryNameKo: "대한민국",
      latitude: 37.4602,
      longitude: 126.4407,
      searchText: "icn incheon seoul 인천 서울"
    )
  }
  
  func makeArrivalAirport() -> AirportInfo {
    AirportInfo(
      iata: "NRT",
      airportNameEn: "Narita International Airport",
      airportNameKo: "나리타국제공항",
      cityNameEn: "Tokyo",
      cityNameKo: "도쿄",
      countryNameKo: "일본",
      latitude: 35.7719,
      longitude: 140.3929,
      searchText: "nrt narita tokyo 나리타 도쿄"
    )
  }
}
