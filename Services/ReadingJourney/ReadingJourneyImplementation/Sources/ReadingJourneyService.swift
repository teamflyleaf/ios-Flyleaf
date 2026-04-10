//
//  ReadingJourneyService.swift
//  Core
//
//  Created by 여성일 on 3/17/26.
//

import Core
import FirebaseAuth
import FirebaseFirestore
import Foundation
import ReadingJourneyInterface

/// Firestore를 이용해 독서 여행을 생성 및 관리하는 서비스입니다.
///
/// ```swift
/// let service = ReadingJourneyService()
/// let journey = try await service.createWishlistJourney(payload: payload)
/// ```
///
/// - Note:
///   - Firebase Authentication을 통해 현재 로그인된 사용자(uid)를 기준으로 데이터가 저장됩니다.
///   - 동일한 출발지 + 도착지 조합에 대해
///     `wishlist` 또는 `reading` 상태의 여행이 이미 존재하면 생성이 제한됩니다.
///   - 문서 ID(`journeyId`)는 Firestore에서 자동 생성됩니다.
///
public final class ReadingJourneyService: ReadingJourneyServicing {
  private let auth: Auth
  private let db: Firestore
  
  public init(
    auth: Auth = Auth.auth(),
    db: Firestore = Firestore.firestore()
  ) {
    self.auth = auth
    self.db = db
  }
  
  // MARK: - Create
  
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
  ///   - Firestore에는 `nil` 값을 직접 저장할 수 없기 때문에 일부 필드는 `NSNull()`로 저장됩니다.
  public func createJourney(
    payload: JourneyPayload
  ) async throws -> ReadingJourney {
    let uid = try currentUserId()
    
    let distanceKm = Double(
      AirportInfo.distanceKm(
        from: payload.departureAirport,
        to: payload.destinationAirport
      )
    )
    let now = Date()
    
    let journeysRef = journeysCollection(for: uid)
    
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
      "departureAirport": airportDictionary(payload.departureAirport),
      "arrivalAirport": airportDictionary(payload.destinationAirport),
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
  ///   - Firestore에는 `nil` 값을 직접 저장할 수 없기 때문에 일부 필드는 `NSNull()`로 저장됩니다.
  ///   - `reason`이 비어있는 경우, 기본 문구가 랜덤으로 저장됩니다.
  public func createWishlistJourney(
    payload: WishlistTicketPayload
  ) async throws -> ReadingJourney {
    let uid = try currentUserId()
    
    let distanceKm = Double(
      AirportInfo.distanceKm(from: payload.departure, to: payload.destination)
    )
    let now = Date()
    
    let journeysRef = journeysCollection(for: uid)
    
    let trimmedReason = payload.reason.trimmingCharacters(in: .whitespacesAndNewlines)
    let finalReason = trimmedReason.isEmpty ? ReasonProvider.random() : trimmedReason
    
    let documentRef = journeysRef.document()
    
    let document: [String: Any] = [
      "status": ReadingJourneyStatusType.wishlist.rawValue,
      "departureAirport": airportDictionary(payload.departure),
      "arrivalAirport": airportDictionary(payload.destination),
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
  ///   - Firestore에는 `nil` 값을 직접 저장할 수 없기 때문에 일부 필드는 `NSNull()`로 저장됩니다.
  public func createHistoryJourney(
    payload: HistoryPayload
  ) async throws -> ReadingJourney {
    let uid = try currentUserId()
    
    let distanceKm = Double(
      AirportInfo.distanceKm(from: payload.departureAirport, to: payload.destinationAirport)
    )
    let now = Date()
    
    let journeysRef = journeysCollection(for: uid)
    let documentRef = journeysRef.document()
    
    let trimmedReview = payload.review.trimmingCharacters(in: .whitespacesAndNewlines)
    
    let document: [String: Any] = [
      "status": ReadingJourneyStatusType.finished.rawValue,
      "departureAirport": airportDictionary(payload.departureAirport),
      "arrivalAirport": airportDictionary(payload.destinationAirport),
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
  
  // MARK: - Update
  
  /// 진행 중(`reading`) 독서 여행을 완료(`finished`) 상태로 변경합니다.
  ///
  /// - Parameters:
  ///   - journeyId: 완료 처리할 독서 여행 문서 ID
  ///   - review: 사용자가 입력한 감상평
  /// - Returns: 완료 상태로 갱신된 `ReadingJourney`
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - `ReadingJourneyError.invalidDocument`: 문서가 존재하지 않거나 필수 필드가 올바르지 않은 경우
  ///   - `ReadingJourneyError.invalidStatus`: 완료 대상이 `reading` 상태가 아닌 경우
  ///   - 기타 Firestore 네트워크/저장 오류
  public func finishJourney(
    journeyId: String,
    review: String
  ) async throws -> ReadingJourney {
    let uid = try currentUserId()
    let documentRef = journeyDocumentRef(uid: uid, journeyId: journeyId)
    
    let snapshot = try await documentRef.getDocument()
    let data = try validatedDocumentData(from: snapshot, expectedStatus: .reading)
    
    guard let bookData = data["book"] as? [String: Any] else {
      throw ReadingJourneyError.invalidDocument
    }
    
    let book = try bookInfo(from: bookData)
    let trimmedReview = review.trimmingCharacters(in: .whitespacesAndNewlines)
    let now = Date()
    
    return try await updateAndFetchJourney(
      documentRef: documentRef,
      journeyId: journeyId,
      fields: [
        "status": ReadingJourneyStatusType.finished.rawValue,
        "finishedAt": now,
        "currentPage": book.itemPage,
        "remainingDistanceKm": 0,
        "progressUpdatedAt": now,
        "review": trimmedReview.isEmpty ? NSNull() : trimmedReview,
        "updatedAt": now,
        "lastUpdatedAt": now
      ]
    )
  }
  
  /// 진행 중인 독서 여행의 현재 페이지를 수정합니다.
  ///
  /// - Parameters:
  ///   - journeyId: 수정할 독서 여행 문서 ID
  ///   - currentPage: 사용자가 입력한 현재 페이지
  /// - Returns: 현재 페이지와 진행도가 반영된 `ReadingJourney`
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - `ReadingJourneyError.invalidDocument`: 문서가 존재하지 않거나 필수 데이터가 올바르지 않은 경우
  ///   - 기타 Firestore 조회/저장 오류
  ///
  /// - Important:
  ///   - 입력된 `currentPage`는 `0...book.itemPage` 범위로 보정됩니다.
  ///   - 진행도는 `currentPage / itemPage` 기준으로 계산됩니다.
  ///   - 계산된 진행도에 따라 `remainingDistanceKm`가 함께 갱신됩니다.
  ///   - 수정 시 `progressUpdatedAt`, `updatedAt`, `lastUpdatedAt`도 함께 업데이트됩니다.
  public func updateJourneyCurrentPage(
    journeyId: String,
    currentPage: Int
  ) async throws -> ReadingJourney {
    let uid = try currentUserId()
    let documentRef = journeyDocumentRef(uid: uid, journeyId: journeyId)
    
    let snapshot = try await documentRef.getDocument()
    let data = try validatedDocumentData(from: snapshot)
    
    let journey = try readingJourney(from: journeyId, data: data)
    
    let maxPage = journey.book.itemPage
    let clampedPage = min(max(0, currentPage), maxPage)
    
    let progress = min(max(Double(clampedPage) / Double(maxPage), 0), 1)
    let remainingDistanceKm = max(journey.distanceKm * (1 - progress), 0)
    let now = Date()
    
    return try await updateAndFetchJourney(
      documentRef: documentRef,
      journeyId: journeyId,
      fields: [
        "currentPage": clampedPage,
        "remainingDistanceKm": remainingDistanceKm,
        "progressUpdatedAt": now,
        "updatedAt": now,
        "lastUpdatedAt": now
      ]
    )
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
  public func updateJourneyStatusToReading(
    journeyId: String,
    startDate: Date,
    currentPage: Int
  ) async throws -> ReadingJourney {
    let uid = try currentUserId()
    
    let journeysRef = journeysCollection(for: uid)
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
    
    return try await updateAndFetchJourney(
      documentRef: documentRef,
      journeyId: journeyId,
      fields: [
        "status": ReadingJourneyStatusType.reading.rawValue,
        "startedAt": startDate,
        "currentPage": currentPage,
        "progressUpdatedAt": now,
        "remainingDistanceKm": remainingDistanceKm,
        "updatedAt": now,
        "lastUpdatedAt": now
      ]
    )
  }
  
  /// 히스토리(`finished`) 상태의 독서 여행 날짜를 수정합니다.
  ///
  /// - Parameters:
  ///   - journeyId: 수정할 독서 여행 문서 ID
  ///   - startDate: 수정할 시작일
  ///   - finishDate: 수정할 종료일
  /// - Returns: 날짜가 갱신된 `ReadingJourney`
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - `ReadingJourneyError.invalidDocument`: 문서가 존재하지 않거나 필수 데이터가 올바르지 않은 경우
  ///   - `ReadingJourneyError.invalidStatus`: 수정 대상이 `finished` 상태가 아닌 경우
  ///   - 기타 Firestore 네트워크/저장 오류
  public func updateFinishedJourneyDates(
    journeyId: String,
    startDate: Date,
    finishDate: Date
  ) async throws -> ReadingJourney {
    let uid = try currentUserId()
    
    guard startDate <= finishDate else {
      throw ReadingJourneyError.invalidDocument
    }
    
    let documentRef = journeyDocumentRef(uid: uid, journeyId: journeyId)
    
    let snapshot = try await documentRef.getDocument()
    _ = try validatedDocumentData(from: snapshot, expectedStatus: .finished)
    
    let now = Date()
    
    return try await updateAndFetchJourney(
      documentRef: documentRef,
      journeyId: journeyId,
      fields: [
        "startedAt": startDate,
        "finishedAt": finishDate,
        "progressUpdatedAt": finishDate,
        "updatedAt": now,
        "lastUpdatedAt": now
      ]
    )
  }
  
  /// 히스토리(`finished`) 상태의 독서 여행 감상평을 수정합니다.
  ///
  /// - Parameters:
  ///   - journeyId: 수정할 독서 여행 문서 ID
  ///   - review: 수정할 감상평
  /// - Returns: 감상평이 갱신된 `ReadingJourney`
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - `ReadingJourneyError.invalidDocument`: 문서가 존재하지 않거나 필수 데이터가 올바르지 않은 경우
  ///   - `ReadingJourneyError.invalidStatus`: 수정 대상이 `finished` 상태가 아닌 경우
  ///   - 기타 Firestore 네트워크/저장 오류
  public func updateFinishedJourneyReview(
    journeyId: String,
    review: String
  ) async throws -> ReadingJourney {
    let uid = try currentUserId()
    let documentRef = journeyDocumentRef(uid: uid, journeyId: journeyId)
    
    let snapshot = try await documentRef.getDocument()
    _ = try validatedDocumentData(from: snapshot, expectedStatus: .finished)
    
    let trimmedReview = review.trimmingCharacters(in: .whitespacesAndNewlines)
    let now = Date()
    
    return try await updateAndFetchJourney(
      documentRef: documentRef,
      journeyId: journeyId,
      fields: [
        "review": trimmedReview.isEmpty ? NSNull() : trimmedReview,
        "updatedAt": now,
        "lastUpdatedAt": now
      ]
    )
  }
  
  // MARK: - Read
  
  /// 현재 사용자의 진행 중(`reading`) 독서 여행 목록을 조회합니다.
  ///
  /// - Returns: `reading` 상태의 `ReadingJourney` 배열
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - Firestore 네트워크/조회 오류
  public func fetchReadingJourneys() async throws -> [ReadingJourney] {
    let uid = try currentUserId()
    
    let snapshot = try await journeysCollection(for: uid)
      .whereField("status", isEqualTo: ReadingJourneyStatusType.reading.rawValue)
      .order(by: "lastUpdatedAt", descending: true)
      .getDocuments()
    
    return try snapshot.documents.map(readingJourney(from:))
  }
  
  /// 현재 사용자의 위시리스트(`wishlist`) 독서 여행 목록을 조회합니다.
  ///
  /// - Returns: `wishlist` 상태의 `ReadingJourney` 배열
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - Firestore 네트워크/조회 오류
  public func fetchWishlist() async throws -> [ReadingJourney] {
    let uid = try currentUserId()
    
    let snapshot = try await journeysCollection(for: uid)
      .whereField("status", isEqualTo: ReadingJourneyStatusType.wishlist.rawValue)
      .order(by: "createdAt", descending: true)
      .getDocuments()
    
    return try snapshot.documents.map(readingJourney(from:))
  }
  
  /// 현재 사용자의 완료(`finished`) 독서 여행 목록을 조회합니다.
  ///
  /// - Returns: `finished` 상태의 `ReadingJourney` 배열
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - Firestore 네트워크/조회 오류
  public func fetchFinishedJourneys() async throws -> [ReadingJourney] {
    let uid = try currentUserId()
    
    let snapshot = try await journeysCollection(for: uid)
      .whereField("status", isEqualTo: ReadingJourneyStatusType.finished.rawValue)
      .order(by: "finishedAt", descending: true)
      .getDocuments()
    
    return try snapshot.documents.map(readingJourney(from:))
  }
  
  // MARK: - Delete
  
  /// 진행 중(`reading`) 상태의 독서 여행을 삭제합니다.
  ///
  /// - Parameter journeyId: 삭제할 독서 여행 문서 ID
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - `ReadingJourneyError.invalidDocument`: 문서가 존재하지 않거나 데이터를 읽을 수 없는 경우
  ///   - `ReadingJourneyError.invalidStatus`: 삭제 대상이 `reading` 상태가 아닌 경우
  ///   - 기타 Firestore 네트워크/삭제 오류
  public func deleteReadingJourney(
    journeyId: String
  ) async throws {
    try await deleteJourney(journeyId: journeyId, expectedStatus: .reading)
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
  public func deleteWishlistJourney(
    journeyId: String
  ) async throws {
    try await deleteJourney(journeyId: journeyId, expectedStatus: .wishlist)
  }
  
  /// 히스토리(`finished`) 상태의 독서 여행을 삭제합니다.
  ///
  /// - Parameter journeyId: 삭제할 독서 여행 문서 ID
  ///
  /// - Throws:
  ///   - `ReadingJourneyError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - `ReadingJourneyError.invalidDocument`: 문서가 존재하지 않거나 데이터를 읽을 수 없는 경우
  ///   - `ReadingJourneyError.invalidStatus`: 삭제 대상이 `finished` 상태가 아닌 경우
  ///   - 기타 Firestore 네트워크/삭제 오류
  public func deleteFinishedJourney(
    journeyId: String
  ) async throws {
    try await deleteJourney(journeyId: journeyId, expectedStatus: .finished)
  }
}

// MARK: - Helper
private extension ReadingJourneyService {
  func currentUserId() throws -> String {
    guard let uid = auth.currentUser?.uid else {
      throw ReadingJourneyError.unauthenticated
    }
    return uid
  }
  
  func journeysCollection(for uid: String) -> CollectionReference {
    db.collection("users")
      .document(uid)
      .collection("readingJourneys")
  }
  
  func journeyDocumentRef(
    uid: String,
    journeyId: String
  ) -> DocumentReference {
    journeysCollection(for: uid).document(journeyId)
  }
  
  func validatedDocumentData(
    from snapshot: DocumentSnapshot,
    expectedStatus: ReadingJourneyStatusType? = nil
  ) throws -> [String: Any] {
    guard let data = snapshot.data() else {
      throw ReadingJourneyError.invalidDocument
    }
    
    if let expectedStatus {
      guard
        let statusRaw = data["status"] as? String,
        let status = ReadingJourneyStatusType(rawValue: statusRaw),
        status == expectedStatus
      else {
        throw ReadingJourneyError.invalidStatus
      }
    }
    
    return data
  }
  
  func updateAndFetchJourney(
    documentRef: DocumentReference,
    journeyId: String,
    fields: [AnyHashable: Any]
  ) async throws -> ReadingJourney {
    try await documentRef.updateData(fields)
    
    let updatedSnapshot = try await documentRef.getDocument()
    guard let updatedData = updatedSnapshot.data() else {
      throw ReadingJourneyError.invalidDocument
    }
    
    return try readingJourney(from: journeyId, data: updatedData)
  }
  
  func deleteJourney(
    journeyId: String,
    expectedStatus: ReadingJourneyStatusType
  ) async throws {
    let uid = try currentUserId()
    let documentRef = journeyDocumentRef(uid: uid, journeyId: journeyId)
    
    let snapshot = try await documentRef.getDocument()
    _ = try validatedDocumentData(from: snapshot, expectedStatus: expectedStatus)
    
    try await documentRef.delete()
  }
  
  func airportDictionary(_ airport: AirportInfo) -> [String: Any] {
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
  
  func readingJourney(
    from document: QueryDocumentSnapshot
  ) throws -> ReadingJourney {
    try readingJourney(from: document.documentID, data: document.data())
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
