//
//  AirportSearchServiceTests.swift
//  AirportSearchTests
//
//  Created by 여성일 on now.
//

import XCTest
@testable import AirportSearchImplementation
@testable import AirportSearchInterface
@testable import AirportSearchTesting

final class AirportSearchServiceTests: XCTestCase {
  private var sut: AirportSearchService!
  
  override func setUp() {
    super.setUp()
    sut = AirportSearchService()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
}
