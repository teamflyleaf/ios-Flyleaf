//
//  RegisterHistoryViewModel.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import Foundation
import ReadingJourneyInterface

public final class RegisterHistoryViewModel {
  private let readingJourneyService: ReadingJourneyServicing
  
  var onUploadStateChanged: ((Bool) -> Void)?
  var onUploadSuccess: ((ReadingJourney) -> Void)?
  var onError: ((String) -> Void)?
  
  var onSelectedBookChanged: ((BookInfo) -> Void)?
  var onSelectDepartureChanged: ((AirportInfo) -> Void)?
  var onSelectDestinationChanged: ((AirportInfo) -> Void)?
  var onBookStepNextButtonEnabledChanged: ((Bool) -> Void)?
  
  // 사용자가 선택한 책 정보
  private(set) var selectedBook: BookInfo? {
    didSet {
      guard let selectedBook else { return }
      onSelectedBookChanged?(selectedBook)
    }
  }
  
  // 사용자가 입력한 시작일
  private(set) var startDate: Date? {
    didSet { validateBookStepNextButton() }
  }
  
  // 사용자가 입력한 종료일
  private(set) var finishDate: Date? {
    didSet { validateBookStepNextButton() }
  }
  
  // 사용자가 입력한 리뷰 텍스트
  private(set) var reviewText: String = ""
  
  // 사용자가 선택한 출발 공항 정보
  private(set) var departureAirport: AirportInfo? {
    didSet {
      guard let departureAirport else { return }
      onSelectDepartureChanged?(departureAirport)
    }
  }
  
  // 사용자가 선택한 도착 공항 정보
  private(set) var destinationAirport: AirportInfo? {
    didSet {
      guard let destinationAirport else { return }
      onSelectDestinationChanged?(destinationAirport)
    }
  }
  
  public init(
    readingJourneyService: ReadingJourneyServicing
  ) {
    self.readingJourneyService = readingJourneyService
  }
  
  // MARK: - Public Method
  /// 선택된 책을 업데이트합니다.
  ///
  /// - Parameter item: 선택된 도서 정보
  ///
  /// - Note:
  ///   - 값 변경 시 `onSelectedBookChanged`가 호출됩니다.
  func updateSelectedBook(_ item: BookInfo) {
    selectedBook = item
  }
  
  /// 사용자 입력 리뷰 텍스트를 업데이트합니다.
  ///
  /// - Parameter text: 입력된 텍스트
  func updateReviewText(_ text: String) {
    reviewText = text
  }
  
  func updateStartDate(_ date: Date) {
    startDate = date
  }
  
  func updateFinishDate(_ date: Date) {
    finishDate = date
  }
  
  /// 출발 공항을 업데이트합니다.
  ///
  /// - Parameter airport: 선택된 출발 공항
  ///
  /// - Note:
  ///   - 값 변경 시 `onSelectDepartureChanged`가 호출됩니다.
  func updateDepartureAirport(_ airport: AirportInfo) {
    departureAirport = airport
  }
  
  /// 도착 공항을 업데이트합니다.
  ///
  /// - Parameter airport: 선택된 도착 공항
  ///
  /// - Note:
  ///   - 값 변경 시 `onSelectDestinationChanged`가 호출됩니다.
  func updateDestinationAirport(_ airport: AirportInfo) {
    destinationAirport = airport
  }
  
  /// 도착 공항을 선택할 수 있는지 여부를 반환합니다.
  ///
  /// - Returns: 출발 공항이 선택된 상태라면 `true`
  func canSelectDestinationAirport() -> Bool {
    departureAirport != nil
  }
  
  /// 전달된 공항이 현재 도착 공항과 동일한지 확인합니다.
  ///
  /// - Parameter airport: 비교할 공항
  /// - Returns: 동일하면 `true`
  func isSameAsDestination(_ airport: AirportInfo) -> Bool {
    destinationAirport?.iata == airport.iata
  }
  
  /// 전달된 공항이 현재 출발 공항과 동일한지 확인합니다.
  ///
  /// - Parameter airport: 비교할 공항
  /// - Returns: 동일하면 `true`
  func isSameAsDeparture(_ airport: AirportInfo) -> Bool {
    departureAirport?.iata == airport.iata
  }
  
  func uploadReadingJourney() async {
    guard let payload = makePayload() else {
      onError?("히스토리 저장에 필요한 정보가 부족합니다.")
      return
    }
    
    onUploadStateChanged?(true)
    
    defer {
      onUploadStateChanged?(false)
    }
    
    do {
      let journey = try await readingJourneyService.createHistoryJourney(
        payload: payload
      )
      onUploadSuccess?(journey)
    } catch {
      let message = (error as? LocalizedError)?.errorDescription ?? "독서 여행 저장에 실패했습니다."
      onError?(message)
    }
  }
}

// MARK: - Private
private extension RegisterHistoryViewModel {
  func validateBookStepNextButton() {
    let isEnabled = startDate != nil && finishDate != nil

    onBookStepNextButtonEnabledChanged?(isEnabled)
  }
  
  func makePayload() -> HistoryPayload? {
    guard
      let selectedBook,
      let startDate,
      let finishDate,
      let departureAirport,
      let destinationAirport
    else {
      return nil
    }
    
    return HistoryPayload(
      book: selectedBook,
      startDate: startDate,
      finishDate: finishDate,
      review: reviewText,
      departureAirport: departureAirport,
      destinationAirport: destinationAirport
    )
  }
}
