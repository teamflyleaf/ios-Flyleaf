//
//  AuthError.swift
//  Core
//
//  Created by 여성일 on 3/7/26.
//

public enum AuthError: Error {
  case invalidToken
  case signInFailed
  case firebaseError
  case unknown
}
