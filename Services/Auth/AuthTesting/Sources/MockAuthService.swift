//
//  MockAuthService.swift
//  AuthTesting
//
//  Created by 여성일 on now.
//

import AuthInterface
import Core
import Foundation

public final class MockAuthService: AuthServicing {
  public init() {}
  
  public var isSignedIn: Bool = false
  
  public func signInWithApple(payload: AppleLoginPayload) async throws -> AppUser {
    fatalError()
  }
}
