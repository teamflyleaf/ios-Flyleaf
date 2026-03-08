//
//  FirebaseAuthService.swift
//  Core
//
//  Created by 여성일 on 3/7/26.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore

public final class FirebaseAuthService: AuthServicing {
  public init() {}

  public var isSignedIn: Bool {
    Auth.auth().currentUser != nil
  }
  
  public func signInWithApple(
    payload: AppleLoginPayload
  ) async throws -> User {
    let firebaseCredential = OAuthProvider.appleCredential(
      withIDToken: payload.idToken,
      rawNonce: payload.rawNonce,
      fullName: nil
    )
    
    let result: AuthDataResult
    
    do {
      result = try await Auth.auth().signIn(with: firebaseCredential)
    } catch {
      throw AuthError.signInFailed
    }
    
    return User(
      id: result.user.uid,
      name: payload.name,
      email: payload.email
    )
  }
}
