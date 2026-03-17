//
//  APIKey.swift
//  Core
//
//  Created by 여성일 on 3/12/26.
//

import Foundation

enum APIKey {
  static var aladin: String {
    guard let key = Bundle.main.object(
      forInfoDictionaryKey: "ALADIN_TTB_KEY"
    ) as? String else {
      fatalError("ALADIN_TTB_KEY not found in Info.plist")
    }

    return key
  }
}
