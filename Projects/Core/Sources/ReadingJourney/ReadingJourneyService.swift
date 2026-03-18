//
//  ReadingJourneyService.swift
//  Core
//
//  Created by 여성일 on 3/17/26.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

/// Firestore를 이용해 독서 여행을 생성 및 관리하는 서비스입니다.
///
/// ```swift
/// let service = FirebaseReadingJourneyService()
/// let journey = try await service.createWishlistJourney(payload: payload)
/// ```
///
/// - Note:
///   - Firebase Authentication을 통해 현재 로그인된 사용자(uid)를 기준으로 데이터가 저장됩니다.
///   - 동일한 출발지 + 도착지 조합에 대해
///     `wishlist` 또는 `reading` 상태의 여행이 이미 존재하면 생성이 제한됩니다.
///   - 문서 ID(`journeyId`)는 Firestore에서 자동 생성됩니다.
///
public final class FirebaseReadingJourneyService: ReadingJourneyServicing {
  private let auth: Auth
  private let db: Firestore
  
  public init(
    auth: Auth = Auth.auth(),
    db: Firestore = Firestore.firestore()
  ) {
    self.auth = auth
    self.db = db
  }
  
  /// 위시리스트(읽고 싶은 책) 상태의 독서 여행을 생성합니다.
  ///
  /// - Parameter payload: 책, 출발지, 도착지, 이유 등을 포함한 생성 데이터
  /// - Returns: 생성된 `ReadingJourney` 모델
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - `ReadingJourneyError.duplicateJourney`: 동일 노선의 진행 중 여행이 이미 존재하는 경우
  ///   - 기타 Firestore 네트워크/저장 오류
  ///
  /// - Important:
  ///   - 동일한 출발지 + 도착지 조합에 대해
  ///     `wishlist` 또는 `reading` 상태가 존재하면 생성이 차단됩니다.
  ///   - Firestore에는 `nil` 값을 직접 저장할 수 없기 때문에
  ///     일부 필드는 `NSNull()`로 저장됩니다.
  public func createWishlistJourney(
    payload: WishlistTicketPayload
  ) async throws -> ReadingJourney {
    guard let uid = auth.currentUser?.uid else {
      throw ReadingJourneyError.unauthenticated
    }
    
    let distanceKm = Double(
      AirportInfo.distanceKm(from: payload.departure, to: payload.destination)
    )
    let now = Date()
    
    let journeysRef = db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
    
    // 같은 노선 병렬 진행 금지
    // departure + arrival 이 같고 status 가 wishlist 또는 reading 이면 생성 막기
    let duplicateSnapshot = try await journeysRef
      .whereField("departureAirport.iata", isEqualTo: payload.departure.iata)
      .whereField("arrivalAirport.iata", isEqualTo: payload.destination.iata)
      .whereField(
        "status",
        in: [
          ReadingJourneyStatusType.wishlist.rawValue,
          ReadingJourneyStatusType.reading.rawValue
        ]
      )
      .getDocuments()
    
    guard duplicateSnapshot.documents.isEmpty else {
      throw ReadingJourneyError.duplicateJourney
    }
    
    let documentRef = journeysRef.document()
    
    let document: [String: Any] = [
      "status": ReadingJourneyStatusType.wishlist.rawValue,
      "departureAirport": departureAirportDictionary(payload.departure),
      "arrivalAirport": arrivalAirportDictionary(payload.destination),
      "distanceKm": distanceKm,
      "remainingDistanceKm": distanceKm,
      "book": bookDictionary(payload.book),
      "reason": payload.reason,
      "startedAt": NSNull(),
      "finishedAt": NSNull(),
      "currentPage": NSNull(),
      "progressUpdatedAt": NSNull(),
      "review": NSNull(),
      "createdAt": now,
      "updatedAt": NSNull(),
      "lastUpdatedAt": now
    ]
    
    try await documentRef.setData(document)
    
    return ReadingJourney(
      id: documentRef.documentID,
      status: .wishlist,
      departureAirport: payload.departure,
      arrivalAirport: payload.destination,
      distanceKm: distanceKm,
      remainingDistanceKm: distanceKm,
      book: payload.book,
      reason: payload.reason,
      startedAt: nil,
      finishedAt: nil,
      currentPage: nil,
      progressUpdatedAt: nil,
      review: nil,
      createdAt: now,
      updatedAt: nil,
      lastUpdatedAt: now
    )
  }
  
  /// 히스토리(다 읽은 책) 상태의 독서 여행을 생성합니다.
  ///
  /// - Parameter payload: 책, 출발지, 도착지, 시작일, 종료일, 감상평 등을 포함한 생성 데이터
  /// - Returns: 생성된 `ReadingJourney` 모델
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - `ReadingJourneyError.duplicateJourney`: 동일 노선의 진행 중 여행이 이미 존재하는 경우
  ///   - 기타 Firestore 네트워크/저장 오류
  ///
  /// - Important:
  ///   - Firestore에는 `nil` 값을 직접 저장할 수 없기 때문에
  ///     일부 필드는 `NSNull()`로 저장됩니다.
  public func createHistoryJourney(
    payload: HistoryPayload
  ) async throws -> ReadingJourney {
    guard let uid = auth.currentUser?.uid else {
      throw ReadingJourneyError.unauthenticated
    }
    
    let distanceKm = Double(
      AirportInfo.distanceKm(from: payload.departureAirport, to: payload.destinationAirport)
    )
    let now = Date()
    
    let journeysRef = db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
    
    let documentRef = journeysRef.document()
    
    let trimmedReview = payload.review.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let document: [String: Any] = [
      "status": ReadingJourneyStatusType.finished.rawValue,
      "departureAirport": departureAirportDictionary(payload.departureAirport),
      "arrivalAirport": arrivalAirportDictionary(payload.destinationAirport),
      "distanceKm": distanceKm,
      "remainingDistanceKm": 0,
      "book": bookDictionary(payload.book),
      "reason": NSNull(),
      "startedAt": payload.startDate,
      "finishedAt": payload.finishDate,
      "currentPage": payload.book.itemPage,
      "progressUpdatedAt": payload.finishDate,
      "review": trimmedReview.isEmpty ? NSNull() : trimmedReview,
      "createdAt": now,
      "updatedAt": NSNull(),
      "lastUpdatedAt": now
    ]
    
    try await documentRef.setData(document)
    
    return ReadingJourney(
      id: documentRef.documentID,
      status: .finished,
      departureAirport: payload.departureAirport,
      arrivalAirport: payload.destinationAirport,
      distanceKm: distanceKm,
      remainingDistanceKm: 0,
      book: payload.book,
      reason: nil,
      startedAt: payload.startDate,
      finishedAt: payload.finishDate,
      currentPage: payload.book.itemPage,
      progressUpdatedAt: payload.finishDate,
      review: trimmedReview.isEmpty ? nil : trimmedReview,
      createdAt: now,
      updatedAt: nil,
      lastUpdatedAt: now
    )
  }
}

// MARK: - Private
private extension FirebaseReadingJourneyService {
  // AirportInfo를 Firestore 저장용 딕셔너리로 변환
  func departureAirportDictionary(_ airport: AirportInfo) -> [String: Any] {
    [
      "iata": airport.iata,
      "airportNameEn": airport.airportNameEn,
      "airportNameKo": airport.airportNameKo,
      "cityNameEn": airport.cityNameEn,
      "cityNameKo": airport.cityNameKo,
      "countryNameKo": airport.countryNameKo,
      "latitude": airport.latitude,
      "longitude": airport.longitude,
      "searchText": airport.searchText
    ]
  }
  
  // AirportInfo를 Firestore 저장용 딕셔너리로 변환
  func arrivalAirportDictionary(_ airport: AirportInfo) -> [String: Any] {
    [
      "iata": airport.iata,
      "airportNameEn": airport.airportNameEn,
      "airportNameKo": airport.airportNameKo,
      "cityNameEn": airport.cityNameEn,
      "cityNameKo": airport.cityNameKo,
      "countryNameKo": airport.countryNameKo,
      "latitude": airport.latitude,
      "longitude": airport.longitude,
      "searchText": airport.searchText
    ]
  }
  
  // BookInfo를 Firestore 저장용 딕셔너리로 변환
  func bookDictionary(_ book: BookInfo) -> [String: Any] {
    [
      "isbn13": book.isbn13,
      "title": book.title,
      "author": book.author,
      "publisher": book.publisher,
      "itemPage": book.itemPage,
      "cover": book.cover
    ]
  }
}
