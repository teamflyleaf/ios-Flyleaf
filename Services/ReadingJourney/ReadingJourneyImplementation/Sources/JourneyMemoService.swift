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
  
  public func createMemo(
    journeyId: String,
    memo: JourneyMemo
  ) async throws {
    guard let uid = auth.currentUser?.uid else {
      throw JourneyMemoError.unauthenticated
    }
    
    try db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
      .document(journeyId)
      .collection("memos")
      .document(memo.id)
      .setData(from: memo)
  }
  
  public func updateMemo(
    journeyId: String,
    memo: JourneyMemo
  ) async throws {
    guard let uid = auth.currentUser?.uid else {
      throw JourneyMemoError.unauthenticated
    }
    
    try db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
      .document(journeyId)
      .collection("memos")
      .document(memo.id)
      .setData(from: memo, merge: true)
  }
  
  public func fetchMemos(
    journeyId: String
  ) async throws -> [JourneyMemo] {
    guard let uid = auth.currentUser?.uid else {
      throw JourneyMemoError.unauthenticated
    }
    
    let snapshot = try await db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
      .document(journeyId)
      .collection("memos")
      .order(by: "createdAt", descending: true)
      .getDocuments()
    
    return try snapshot.documents.compactMap {
      try $0.data(as: JourneyMemo.self)
    }
  }
  
  public func deleteMemo(
    journeyId: String,
    memoId: String
  ) async throws {
    guard let uid = auth.currentUser?.uid else {
      throw JourneyMemoError.unauthenticated
    }
    
    try await db
      .collection("users")
      .document(uid)
      .collection("readingJourneys")
      .document(journeyId)
      .collection("memos")
      .document(memoId)
      .delete()
  }
}
