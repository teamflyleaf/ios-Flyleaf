//
//  SplashLoadingStep.swift
//  App
//
//  Created by 여성일 on 5/30/26.
//

enum SplashLoadingStep {
  case checkingAuth
  case fetchingData
}

extension SplashLoadingStep {
  var displayText: String {
    switch self {
    case .checkingAuth:
      return "로그인 정보를 확인하고 있어요"
    case .fetchingData:
      return "여행 데이터를 불러오고 있어요"
    }
  }
}
