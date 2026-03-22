//
//  MockJourneyMemoService.swift
//  Journey
//
//  Created by 여성일 on 3/22/26.
//

import Core
import Foundation

final class MockJourneyMemoService: JourneyMemoServicing {
  var stubbedFetchMemosResult: [JourneyMemo] = []
  var stubbedFetchMemosError: Error?
  
  var stubbedCreateMemoError: Error?
  var stubbedUpdateMemoError: Error?
  var stubbedDeleteMemoError: Error?
  
  private(set) var fetchMemosCallCount = 0
  private(set) var createMemoCallCount = 0
  private(set) var updateMemoCallCount = 0
  private(set) var deleteMemoCallCount = 0
  
  private(set) var lastFetchJourneyId: String?
  private(set) var lastCreateJourneyId: String?
  private(set) var lastUpdateJourneyId: String?
  private(set) var lastDeleteJourneyId: String?
  
  private(set) var lastCreatedMemo: JourneyMemo?
  private(set) var lastUpdatedMemo: JourneyMemo?
  private(set) var lastDeletedMemoId: String?
  
  func createMemo(
    journeyId: String,
    memo: JourneyMemo
  ) async throws {
    createMemoCallCount += 1
    lastCreateJourneyId = journeyId
    lastCreatedMemo = memo
    
    if let stubbedCreateMemoError {
      throw stubbedCreateMemoError
    }
  }
  
  func updateMemo(
    journeyId: String,
    memo: JourneyMemo
  ) async throws {
    updateMemoCallCount += 1
    lastUpdateJourneyId = journeyId
    lastUpdatedMemo = memo
    
    if let stubbedUpdateMemoError {
      throw stubbedUpdateMemoError
    }
  }
  
  func fetchMemos(
    journeyId: String
  ) async throws -> [JourneyMemo] {
    fetchMemosCallCount += 1
    lastFetchJourneyId = journeyId
    
    if let stubbedFetchMemosError {
      throw stubbedFetchMemosError
    }
    
    return stubbedFetchMemosResult
  }
  
  func deleteMemo(
    journeyId: String,
    memoId: String
  ) async throws {
    deleteMemoCallCount += 1
    lastDeleteJourneyId = journeyId
    lastDeletedMemoId = memoId
    
    if let stubbedDeleteMemoError {
      throw stubbedDeleteMemoError
    }
  }
}
