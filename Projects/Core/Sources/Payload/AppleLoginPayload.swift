//
//  AppleLoginPayload.swift
//  Core
//
//  Created by 여성일 on 3/8/26.
//

public struct AppleLoginPayload: Equatable, Sendable {
  public let idToken: String
  public let rawNonce: String
  public let name: String?
  public let email: String?

  public init(
    idToken: String,
    rawNonce: String,
    name: String?,
    email: String?
  ) {
    self.idToken = idToken
    self.rawNonce = rawNonce
    self.name = name
    self.email = email
  }
}
