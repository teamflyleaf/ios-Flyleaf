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
  ///   - Firestore에는 `nil` 값을 직접 저장할 수 없기 때문에
  ///     일부 필드는 `NSNull()`로 저장됩니다.
  ///   - `reason`이 비어있는 경우, 기본 문구가 랜덤으로 저장됩니다.
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
    
    let trimmedReason = payload.reason.trimmingCharacters(in: .whitespacesAndNewlines)
    let finalReason = trimmedReason.isEmpty ? ReasonProvider.random() : trimmedReason
    
    let documentRef = journeysRef.document()
    
    let document: [String: Any] = [
      "status": ReadingJourneyStatusType.wishlist.rawValue,
      "departureAirport": departureAirportDictionary(payload.departure),
      "arrivalAirport": arrivalAirportDictionary(payload.destination),
      "distanceKm": distanceKm,
      "remainingDistanceKm": distanceKm,
      "book": bookDictionary(payload.book),
      "reason": finalReason,
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
      reason: finalReason,
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
  ///   - 동일한 출발지 + 도착지 조합에 대해
  ///     `wishlist` 또는 `reading` 상태가 존재하면 생성이 차단됩니다.
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
  
  /// 기본 Journey(읽고 있는 책) 상태의 독서 여행을 생성합니다.
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
  public func createJourney(
    payload: JourneyPayload
  ) async throws -> ReadingJourney {
    guard let uid = auth.currentUser?.uid else {
      throw ReadingJourneyError.unauthenticated
    }
    
    let distanceKm = Double(
      AirportInfo.distanceKm(
        from: payload.departureAirport,
        to: payload.destinationAirport
      )
    )
    let now = Date()
    
    let journeysRef = db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
    
    // 같은 노선의 wishlist / reading 중복 방지
    let duplicateSnapshot = try await journeysRef
      .whereField("departureAirport.iata", isEqualTo: payload.departureAirport.iata)
      .whereField("arrivalAirport.iata", isEqualTo: payload.destinationAirport.iata)
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
    
    let progress = min(
      max(Double(payload.currentPage) / Double(payload.book.itemPage), 0),
      1
    )
    let remainingDistanceKm = max(distanceKm * (1 - progress), 0)
    
    let document: [String: Any] = [
      "status": ReadingJourneyStatusType.reading.rawValue,
      "departureAirport": departureAirportDictionary(payload.departureAirport),
      "arrivalAirport": arrivalAirportDictionary(payload.destinationAirport),
      "distanceKm": distanceKm,
      "remainingDistanceKm": remainingDistanceKm,
      "book": bookDictionary(payload.book),
      "reason": NSNull(),
      "startedAt": payload.startDate,
      "finishedAt": NSNull(),
      "currentPage": payload.currentPage,
      "progressUpdatedAt": now,
      "review": NSNull(),
      "createdAt": now,
      "updatedAt": NSNull(),
      "lastUpdatedAt": now
    ]
    
    try await documentRef.setData(document)
    
    return ReadingJourney(
      id: documentRef.documentID,
      status: .reading,
      departureAirport: payload.departureAirport,
      arrivalAirport: payload.destinationAirport,
      distanceKm: distanceKm,
      remainingDistanceKm: remainingDistanceKm,
      book: payload.book,
      reason: nil,
      startedAt: payload.startDate,
      finishedAt: nil,
      currentPage: payload.currentPage,
      progressUpdatedAt: now,
      review: nil,
      createdAt: now,
      updatedAt: nil,
      lastUpdatedAt: now
    )
  }
  
  /// 현재 사용자의 진행 중(`reading`) 독서 여행 목록을 조회합니다.
  ///
  /// - Returns: `reading` 상태의 `ReadingJourney` 배열
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - Firestore 네트워크/조회 오류
  ///
  /// - Note:
  ///   - 조회된 문서는 `readingJourney(from:)`를 통해 모델로 변환됩니다.
  public func fetchReadingJourneys() async throws -> [ReadingJourney] {
    guard let uid = auth.currentUser?.uid else {
      throw ReadingJourneyError.unauthenticated
    }
    
    let snapshot = try await db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
      .whereField("status", isEqualTo: ReadingJourneyStatusType.reading.rawValue)
      .getDocuments()
    
    return try snapshot.documents.map { document in
      try readingJourney(from: document)
    }
  }
  
  /// 현재 사용자의 위시리스트(`wishlist`) 독서 여행 목록을 조회합니다.
  ///
  /// - Returns: `wishlist` 상태의 `ReadingJourney` 배열
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - Firestore 네트워크/조회 오류
  ///
  /// - Note:
  ///   - 조회된 문서는 `readingJourney(from:)`를 통해 모델로 변환됩니다.
  public func fetchWishlist() async throws -> [ReadingJourney] {
    guard let uid = auth.currentUser?.uid else {
      throw ReadingJourneyError.unauthenticated
    }
    
    let snapshot = try await db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
      .whereField("status", isEqualTo: ReadingJourneyStatusType.wishlist.rawValue)
      .order(by: "createdAt", descending: true)
      .getDocuments()
    
    return try snapshot.documents.map { document in
      try readingJourney(from: document)
    }
  }
  
  /// 위시리스트(`wishlist`) 상태의 독서 여행을 읽는 중(`reading`) 상태로 변경합니다.
  ///
  /// - Parameters:
  ///   - journeyId: 상태를 변경할 독서 여행 문서 ID
  ///   - startDate: 독서를 시작한 날짜
  ///   - currentPage: 현재까지 읽은 페이지 수
  /// - Returns: 상태가 갱신된 `ReadingJourney` 모델
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - `ReadingJourneyError.invalidDocument`: 문서가 존재하지 않거나 필수 필드가 올바르지 않은 경우
  ///   - `ReadingJourneyError.duplicateJourney`: 동일 노선의 `reading` 상태 여행이 이미 존재하는 경우
  ///   - 기타 Firestore 네트워크/저장 오류
  ///
  /// - Important:
  ///   - `wishlist` 상태의 문서만 `reading` 상태로 변경할 수 있습니다.
  ///   - 진행도는 `currentPage / itemPage` 기준으로 계산되며,
  ///     이에 따라 `remainingDistanceKm`도 함께 갱신됩니다.
  ///   - 상태 변경 시 `startedAt`, `progressUpdatedAt`, `updatedAt`, `lastUpdatedAt`이 함께 업데이트됩니다.
  public func updateJourneyStatusToReading(
    journeyId: String,
    startDate: Date,
    currentPage: Int
  ) async throws -> ReadingJourney {
    guard let uid = auth.currentUser?.uid else {
      throw ReadingJourneyError.unauthenticated
    }
    
    let journeysRef = db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
    
    let documentRef = journeysRef.document(journeyId)
    let snapshot = try await documentRef.getDocument()
    
    guard let data = snapshot.data() else {
      throw ReadingJourneyError.invalidDocument
    }
    
    guard
      let statusRaw = data["status"] as? String,
      let status = ReadingJourneyStatusType(rawValue: statusRaw),
      status == .wishlist
    else {
      throw ReadingJourneyError.invalidDocument
    }
    
    guard
      let departureAirportData = data["departureAirport"] as? [String: Any],
      let arrivalAirportData = data["arrivalAirport"] as? [String: Any],
      let distanceKm = data["distanceKm"] as? Double,
      let bookData = data["book"] as? [String: Any]
    else {
      throw ReadingJourneyError.invalidDocument
    }
    
    let departureAirport = try airportInfo(from: departureAirportData)
    let arrivalAirport = try airportInfo(from: arrivalAirportData)
    let book = try bookInfo(from: bookData)
    
    let readingDuplicateSnapshot = try await journeysRef
      .whereField("departureAirport.iata", isEqualTo: departureAirport.iata)
      .whereField("arrivalAirport.iata", isEqualTo: arrivalAirport.iata)
      .whereField("status", isEqualTo: ReadingJourneyStatusType.reading.rawValue)
      .getDocuments()
    
    guard readingDuplicateSnapshot.documents.isEmpty else {
      throw ReadingJourneyError.duplicateJourney
    }
    
    let progress = min(max(Double(currentPage) / Double(book.itemPage), 0), 1)
    let remainingDistanceKm = max(distanceKm * (1 - progress), 0)
    let now = Date()
    
    try await documentRef.updateData([
      "status": ReadingJourneyStatusType.reading.rawValue,
      "startedAt": startDate,
      "currentPage": currentPage,
      "progressUpdatedAt": now,
      "remainingDistanceKm": remainingDistanceKm,
      "updatedAt": now,
      "lastUpdatedAt": now
    ])
    
    let updatedSnapshot = try await documentRef.getDocument()
    
    guard let updatedData = updatedSnapshot.data() else {
      throw ReadingJourneyError.invalidDocument
    }
    
    return try readingJourney(from: journeyId, data: updatedData)
  }
  
  /// 위시리스트(`wishlist`) 상태의 독서 여행을 삭제합니다.
  ///
  /// - Parameter journeyId: 삭제할 독서 여행 문서 ID
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - `ReadingJourneyError.invalidDocument`: 문서가 존재하지 않거나 데이터를 읽을 수 없는 경우
  ///   - `ReadingJourneyError.invalidStatus`: 삭제 대상이 `wishlist` 상태가 아닌 경우
  ///   - 기타 Firestore 네트워크/삭제 오류
  ///
  /// - Important:
  ///   - `wishlist` 상태의 문서만 삭제할 수 있습니다.
  ///   - `reading`, `finished` 상태의 여행은 이 메서드로 삭제되지 않습니다.
  public func deleteWishlistJourney(
    journeyId: String
  ) async throws {
    guard let uid = auth.currentUser?.uid else {
      throw ReadingJourneyError.unauthenticated
    }
    
    let documentRef = db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
      .document(journeyId)
    
    let snapshot = try await documentRef.getDocument()
    
    guard let data = snapshot.data() else {
      throw ReadingJourneyError.invalidDocument
    }
    
    guard
      let statusRaw = data["status"] as? String,
      let status = ReadingJourneyStatusType(rawValue: statusRaw),
      status == .wishlist
    else {
      throw ReadingJourneyError.invalidStatus
    }
    
    try await documentRef.delete()
  }
}

// MARK: - Helper
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
      "cover": book.cover,
      "description": book.description
    ]
  }
  
  /// Firestore 문서를 ReadingJourney 모델로 변환합니다.
  ///
  /// - Parameter document: Firestore에서 조회한 문서
  /// - Returns: 변환된 ReadingJourney 모델
  /// - Throws: 필수 필드가 없거나 타입이 맞지 않는 경우 `invalidDocument` 오류 발생
  func readingJourney(
    from document: QueryDocumentSnapshot
  ) throws -> ReadingJourney {
    let data = document.data()
    
    guard
      let statusRawValue = data["status"] as? String,
      let status = ReadingJourneyStatusType(rawValue: statusRawValue),
      let departureAirportData = data["departureAirport"] as? [String: Any],
      let arrivalAirportData = data["arrivalAirport"] as? [String: Any],
      let distanceKm = data["distanceKm"] as? Double,
      let bookData = data["book"] as? [String: Any],
      let createdAtTimestamp = data["createdAt"] as? Timestamp,
      let lastUpdatedAtTimestamp = data["lastUpdatedAt"] as? Timestamp
    else {
      throw ReadingJourneyError.invalidDocument
    }
    
    let departureAirport = try airportInfo(from: departureAirportData)
    let arrivalAirport = try airportInfo(from: arrivalAirportData)
    let book = try bookInfo(from: bookData)
    
    let remainingDistanceKm = data["remainingDistanceKm"] as? Double
    let reason = data["reason"] as? String
    let currentPage = data["currentPage"] as? Int
    let review = data["review"] as? String
    
    let startedAt = (data["startedAt"] as? Timestamp)?.dateValue()
    let finishedAt = (data["finishedAt"] as? Timestamp)?.dateValue()
    let progressUpdatedAt = (data["progressUpdatedAt"] as? Timestamp)?.dateValue()
    let updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue()
    
    return ReadingJourney(
      id: document.documentID,
      status: status,
      departureAirport: departureAirport,
      arrivalAirport: arrivalAirport,
      distanceKm: distanceKm,
      remainingDistanceKm: remainingDistanceKm,
      book: book,
      reason: reason,
      startedAt: startedAt,
      finishedAt: finishedAt,
      currentPage: currentPage,
      progressUpdatedAt: progressUpdatedAt,
      review: review,
      createdAt: createdAtTimestamp.dateValue(),
      updatedAt: updatedAt,
      lastUpdatedAt: lastUpdatedAtTimestamp.dateValue()
    )
  }
  
  func readingJourney(
    from id: String,
    data: [String: Any]
  ) throws -> ReadingJourney {
    guard
      let statusRawValue = data["status"] as? String,
      let status = ReadingJourneyStatusType(rawValue: statusRawValue),
      let departureAirportData = data["departureAirport"] as? [String: Any],
      let arrivalAirportData = data["arrivalAirport"] as? [String: Any],
      let distanceKm = data["distanceKm"] as? Double,
      let bookData = data["book"] as? [String: Any],
      let createdAtTimestamp = data["createdAt"] as? Timestamp,
      let lastUpdatedAtTimestamp = data["lastUpdatedAt"] as? Timestamp
    else {
      throw ReadingJourneyError.invalidDocument
    }

    let departureAirport = try airportInfo(from: departureAirportData)
    let arrivalAirport = try airportInfo(from: arrivalAirportData)
    let book = try bookInfo(from: bookData)

    let remainingDistanceKm = data["remainingDistanceKm"] as? Double
    let reason = data["reason"] as? String
    let currentPage = data["currentPage"] as? Int
    let review = data["review"] as? String

    let startedAt = (data["startedAt"] as? Timestamp)?.dateValue()
    let finishedAt = (data["finishedAt"] as? Timestamp)?.dateValue()
    let progressUpdatedAt = (data["progressUpdatedAt"] as? Timestamp)?.dateValue()
    let updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue()

    return ReadingJourney(
      id: id,
      status: status,
      departureAirport: departureAirport,
      arrivalAirport: arrivalAirport,
      distanceKm: distanceKm,
      remainingDistanceKm: remainingDistanceKm,
      book: book,
      reason: reason,
      startedAt: startedAt,
      finishedAt: finishedAt,
      currentPage: currentPage,
      progressUpdatedAt: progressUpdatedAt,
      review: review,
      createdAt: createdAtTimestamp.dateValue(),
      updatedAt: updatedAt,
      lastUpdatedAt: lastUpdatedAtTimestamp.dateValue()
    )
  }
  
  /// Firestore 딕셔너리를 AirportInfo 모델로 변환합니다.
  ///
  /// - Throws: 필수 필드 누락 시 `invalidDocument`
  func airportInfo(from data: [String: Any]) throws -> AirportInfo {
    guard
      let iata = data["iata"] as? String,
      let airportNameEn = data["airportNameEn"] as? String,
      let airportNameKo = data["airportNameKo"] as? String,
      let cityNameEn = data["cityNameEn"] as? String,
      let cityNameKo = data["cityNameKo"] as? String,
      let countryNameKo = data["countryNameKo"] as? String,
      let latitude = data["latitude"] as? Double,
      let longitude = data["longitude"] as? Double,
      let searchText = data["searchText"] as? String
    else {
      throw ReadingJourneyError.invalidDocument
    }
    
    return AirportInfo(
      iata: iata,
      airportNameEn: airportNameEn,
      airportNameKo: airportNameKo,
      cityNameEn: cityNameEn,
      cityNameKo: cityNameKo,
      countryNameKo: countryNameKo,
      latitude: latitude,
      longitude: longitude,
      searchText: searchText
    )
  }
  
  /// Firestore 딕셔너리를 BookInfo 모델로 변환합니다.
  ///
  /// - Throws: 필수 필드 누락 시 `invalidDocument`
  func bookInfo(from data: [String: Any]) throws -> BookInfo {
    guard
      let isbn13 = data["isbn13"] as? String,
      let title = data["title"] as? String,
      let author = data["author"] as? String,
      let publisher = data["publisher"] as? String,
      let itemPage = data["itemPage"] as? Int,
      let cover = data["cover"] as? String,
      let description = data["description"] as? String
    else {
      throw ReadingJourneyError.invalidDocument
    }
    
    return BookInfo(
      isbn13: isbn13,
      title: title,
      author: author,
      publisher: publisher,
      itemPage: itemPage,
      cover: cover,
      description: description
    )
  }
}

