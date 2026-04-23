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
  var currentUser: AppUser? { get }
  
  func signInWithApple(
    payload: AppleLoginPayload
  ) async throws -> AppUser
  
  func signOut() throws
  
  func deleteAccount() async throws
}
