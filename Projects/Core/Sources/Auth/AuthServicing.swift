//
//  AuthServiceProtocol.swift
//  Core
//
//  Created by 여성일 on 3/7/26.
//

public protocol AuthServicing {
  var isSignedIn: Bool { get }
  func signInWithApple(
    payload: AppleLoginPayload
  ) async throws -> User
}
