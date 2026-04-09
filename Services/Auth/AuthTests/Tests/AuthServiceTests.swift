//
//  AuthServiceTests.swift
//  AuthTests
//
//  Created by 여성일 on now.
//

import XCTest
@testable import AuthImplementation
@testable import AuthInterface
@testable import AuthTesting

final class AuthServiceTests: XCTestCase {
  private var sut: AuthService!
  
  override func setUp() {
    super.setUp()
    sut = AuthService()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
}
