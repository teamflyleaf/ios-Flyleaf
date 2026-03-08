//
//  FirebaseAuthService.swift
//  Core
//
//  Created by 여성일 on 3/7/26.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore

public final class FirebaseAuthService: AuthServiceProtocol {
  public init() {}

  public func signInWithApple(
    credential: ASAuthorizationAppleIDCredential,
    rawNonce: String
  ) async throws -> User {
    guard let tokenData = credential.identityToken,
          let idToken = String(data: tokenData, encoding: .utf8) else {
      throw AuthError.invalidToken
    }
    
    let firebaseCredential = OAuthProvider.appleCredential(
      withIDToken: idToken,
      rawNonce: rawNonce,
      fullName: credential.fullName
    )
    
    let result: AuthDataResult
    
    do {
      result = try await Auth.auth().signIn(with: firebaseCredential)
    } catch {
      throw AuthError.signInFailed
    }
    
    let name = [
      credential.fullName?.familyName,
      credential.fullName?.givenName
    ].compactMap { $0 }.joined()
    
    return User(
      id: result.user.uid,
      name: name.isEmpty ? nil : name,
      email: credential.email
    )
  }
}
