//
//  AuthServicing.swift
//  AuthInterface
//
//  Created by 여성일 on now.
//

import Core
import Foundation

public protocol AuthServicing {
  var isSignedIn: Bool { get }
  func signInWithApple(
    payload: AppleLoginPayload
  ) async throws -> AppUser
}
