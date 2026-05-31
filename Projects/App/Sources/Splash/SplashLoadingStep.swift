//
//  SplashLoadingStep.swift
//  App
//
//  Created by 여성일 on 5/30/26.
//

enum SplashLoadingStep {
  case checkingAuth
}

extension SplashLoadingStep {
  var displayText: String {
    switch self {
    case .checkingAuth:
      return "로그인 정보를 확인하고 있어요"
    }
  }
}
