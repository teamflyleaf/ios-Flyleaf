//
//  AuthService.swift
//  AuthImplementation
//
//  Created by 여성일 on now.
//

import AuthenticationServices
import AuthInterface
import Core
import FirebaseAuth

public final class AuthService: AuthServicing {
  public init() {}

  public var isSignedIn: Bool {
    Auth.auth().currentUser != nil
  }
  
  public func signInWithApple(
    payload: AppleLoginPayload
  ) async throws -> AppUser {
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
    
    return AppUser(
      id: result.user.uid,
      name: payload.name,
      email: payload.email
    )
  }
  
  public func signOut() throws {
    do {
      try Auth.auth().signOut()
    } catch {
      throw AuthError.signOutFailed
    }
  }
}
