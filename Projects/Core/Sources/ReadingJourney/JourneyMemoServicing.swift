//
//  JourneyMemoServicing.swift
//  Core
//
//  Created by 여성일 on 3/22/26.
//

public protocol JourneyMemoServicing {
  func createMemo(
    journeyId: String,
    memo: JourneyMemo
  ) async throws
  
  func updateMemo(
    journeyId: String,
    memo: JourneyMemo
  ) async throws
  
  func fetchMemos(
    journeyId: String
  ) async throws -> [JourneyMemo]
  
  func deleteMemo(
    journeyId: String,
    memoId: String
  ) async throws
}
