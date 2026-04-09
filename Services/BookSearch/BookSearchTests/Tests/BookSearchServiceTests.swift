//
//  BookSearchServiceTests.swift
//  BookSearchTests
//
//  Created by 여성일 on now.
//

import XCTest
@testable import BookSearchImplementation
@testable import BookSearchInterface
@testable import BookSearchTesting

final class BookSearchServiceTests: XCTestCase {
  private var sut: BookSearchService!
  
  override func setUp() {
    super.setUp()
    sut = BookSearchService()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
}
