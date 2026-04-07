//
//  TooltipServiceTests.swift
//  TooltipTests
//
//  Created by 여성일 on now.
//

import XCTest
@testable import TooltipImplementation
@testable import TooltipInterface
@testable import TooltipTesting

final class TooltipServiceTests: XCTestCase {
  private var sut: TooltipService!
  
  override func setUp() {
    super.setUp()
    sut = TooltipService()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
}
