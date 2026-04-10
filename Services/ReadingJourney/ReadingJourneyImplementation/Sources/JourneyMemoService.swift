//
//  JourneyMemoService.swift
//  Core
//
//  Created by 여성일 on 3/22/26.
//

import ReadingJourneyInterface
import FirebaseAuth
import FirebaseFirestore
import Foundation

/// Firestore를 이용해 독서 여행 메모를 생성, 조회, 수정, 삭제하는 서비스입니다.
///
/// ```swift
/// let service = JourneyMemoService()
/// try await service.createMemo(journeyId: journeyId, memo: memo)
/// let memos = try await service.fetchMemos(journeyId: journeyId)
/// ```
///
/// - Note:
///   - Firebase Authentication을 통해 현재 로그인된 사용자(uid)를 기준으로 메모가 저장됩니다.
///   - 메모는 각 독서 여행(`readingJourneys/{journeyId}`) 문서 하위의 `memos` 컬렉션에 저장됩니다.
///   - 메모 조회 시 `createdAt` 기준 내림차순으로 정렬됩니다.
public final class JourneyMemoService: JourneyMemoServicing {
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
  
  /// 특정 독서 여행에 메모를 생성합니다.
  ///
  /// - Parameters:
  ///   - journeyId: 메모를 추가할 독서 여행 문서 ID
  ///   - memo: 저장할 메모 모델
  ///
  /// - Throws:
  ///   - `JourneyMemoError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - 기타 Firestore 인코딩/저장 오류
  ///
  /// - Important:
  ///   - 메모 문서 ID는 `memo.id` 값을 사용합니다.
  public func createMemo(
    journeyId: String,
    memo: JourneyMemo
  ) async throws {
    let uid = try currentUserId()
    
    try memosCollection(uid: uid, journeyId: journeyId)
      .document(memo.id)
      .setData(from: memo)
  }
  
  // MARK: - Read
  
  /// 특정 독서 여행의 메모 목록을 조회합니다.
  ///
  /// - Parameter journeyId: 메모를 조회할 독서 여행 문서 ID
  /// - Returns: `createdAt` 기준 내림차순으로 정렬된 `JourneyMemo` 배열
  ///
  /// - Throws:
  ///   - `JourneyMemoError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - Firestore 조회/디코딩 오류
  ///
  /// - Note:
  ///   - 조회된 문서는 `JourneyMemo` 모델로 디코딩됩니다.
  public func fetchMemos(
    journeyId: String
  ) async throws -> [JourneyMemo] {
    let uid = try currentUserId()
    
    let snapshot = try await memosCollection(uid: uid, journeyId: journeyId)
      .order(by: "createdAt", descending: true)
      .getDocuments()
    
    return try snapshot.documents.map {
      try $0.data(as: JourneyMemo.self)
    }
  }
  
  // MARK: - Update
  
  /// 특정 독서 여행의 메모를 수정합니다.
  ///
  /// - Parameters:
  ///   - journeyId: 수정할 메모가 속한 독서 여행 문서 ID
  ///   - memo: 수정할 메모 모델
  ///
  /// - Throws:
  ///   - `JourneyMemoError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - 기타 Firestore 인코딩/저장 오류
  ///
  /// - Important:
  ///   - `merge: true` 옵션으로 저장되므로 기존 문서의 일부 필드만 갱신할 수 있습니다.
  ///   - 수정 대상 문서 ID는 `memo.id` 값을 사용합니다.
  public func updateMemo(
    journeyId: String,
    memo: JourneyMemo
  ) async throws {
    let uid = try currentUserId()
    
    try memosCollection(uid: uid, journeyId: journeyId)
      .document(memo.id)
      .setData(from: memo, merge: true)
  }
  
  // MARK: - Delete
  
  /// 특정 독서 여행의 메모를 삭제합니다.
  ///
  /// - Parameters:
  ///   - journeyId: 삭제할 메모가 속한 독서 여행 문서 ID
  ///   - memoId: 삭제할 메모 문서 ID
  ///
  /// - Throws:
  ///   - `JourneyMemoError.unauthenticated`: 로그인된 사용자가 없는 경우
  ///   - 기타 Firestore 삭제 오류
  public func deleteMemo(
    journeyId: String,
    memoId: String
  ) async throws {
    let uid = try currentUserId()
    
    try await memosCollection(uid: uid, journeyId: journeyId)
      .document(memoId)
      .delete()
  }
}

// MARK: - Helper
private extension JourneyMemoService {
  func currentUserId() throws -> String {
    guard let uid = auth.currentUser?.uid else {
      throw JourneyMemoError.unauthenticated
    }
    return uid
  }
  
  func memosCollection(
    uid: String,
    journeyId: String
  ) -> CollectionReference {
    db.collection("users")
      .document(uid)
      .collection("readingJourneys")
      .document(journeyId)
      .collection("memos")
  }
}
