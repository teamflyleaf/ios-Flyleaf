//
//  User.swift
//  Core
//
//  Created by 여성일 on 3/7/26.
//

public struct User: Equatable, Sendable {
  public let id: String
  public let name: String?
  public let email: String?

  public init(
    id: String,
    name: String?,
    email: String?
  ) {
    self.id = id
    self.name = name
    self.email = email
  }
}
