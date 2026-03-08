//
//  AuthServiceProtocol.swift
//  Core
//
//  Created by 여성일 on 3/7/26.
//

import AuthenticationServices

public protocol AuthServiceProtocol {
  func signInWithApple(
    credential: ASAuthorizationAppleIDCredential,
    rawNonce: String
  ) async throws -> User
}
