//
//  ReadingJourneyServiceTests.swift
//  ReadingJourneyTests
//
//  Created by 여성일 on now.
//

import XCTest
@testable import ReadingJourneyImplementation
@testable import ReadingJourneyInterface
@testable import ReadingJourneyTesting

final class ReadingJourneyServiceTests: XCTestCase {
  private var sut: ReadingJourneyService!
  
  override func setUp() {
    super.setUp()
    sut = ReadingJourneyService()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
}
