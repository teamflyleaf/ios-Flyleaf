//
//  SearchHistoryServiceTests.swift
//  SearchHistoryTests
//
//  Created by 여성일 on now.
//

import XCTest
@testable import SearchHistoryImplementation
@testable import SearchHistoryInterface
@testable import SearchHistoryTesting

final class SearchHistoryServiceTests: XCTestCase {
  private var sut: SearchHistoryService!
  
  override func setUp() {
    super.setUp()
    sut = SearchHistoryService()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
}
