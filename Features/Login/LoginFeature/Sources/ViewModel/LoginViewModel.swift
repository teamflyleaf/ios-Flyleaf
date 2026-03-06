//
//  LoginViewModel.swift
//  Login
//
//  Created by 여성일 on 3/6/26.
//

public final class LoginViewModel {
  public init() {}
  
  var onLoginSuccess: (() -> Void)?
  
  func handleLoginSuccess() {
    onLoginSuccess?()
  }
}
