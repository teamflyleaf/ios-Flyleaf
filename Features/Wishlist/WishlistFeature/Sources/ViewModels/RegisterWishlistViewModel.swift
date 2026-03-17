//
//  RegisterWishlistViewModel.swift
//  Wishlist
//
//  Created by 여성일 on 3/13/26.
//

import Core
import Foundation

public final class RegisterWishlistViewModel {
  var onSelectedBookChanged: ((BookInfo) -> Void)?
  var onSelectDepartureChanged: ((AirportInfo) -> Void)?
  var onSelectDestinationChanged: ((AirportInfo) -> Void)?
  
  // 사용자가 선택한 책 정보
  private(set) var selectedBook: BookInfo? {
    didSet {
      guard let selectedBook else { return }
      onSelectedBookChanged?(selectedBook)
    }
  }
  
  // 사용자가 입력한 이유 텍스트
  private(set) var reasonText: String = ""
  
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
  
  public init() {}
  
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

  /// 사용자 입력 사유 텍스트를 업데이트합니다.
  ///
  /// - Parameter text: 입력된 텍스트
  func updateReasonText(_ text: String) {
    reasonText = text
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
}
