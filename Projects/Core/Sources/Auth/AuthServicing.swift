//
//  AuthServiceProtocol.swift
//  Core
//
//  Created by 여성일 on 3/7/26.
//

import AuthenticationServices

public protocol AuthServicing {
  var isSignedIn: Bool { get }
  func signInWithApple(
    credential: ASAuthorizationAppleIDCredential,
    rawNonce: String
  ) async throws -> User
}
