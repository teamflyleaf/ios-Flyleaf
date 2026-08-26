//
//  APIKey.swift
//  Core
//
//  Created by 여성일 on 3/12/26.
//

import Foundation

public enum APIKey {
  public static var aladin: String {
    guard let key = Bundle.main.object(
      forInfoDictionaryKey: "ALADIN_TTB_KEY"
    ) as? String else {
      fatalError("ALADIN_TTB_KEY not found in Info.plist")
    }

    return key
  }

  public static var carto: String {
    guard let key = Bundle.main.object(
      forInfoDictionaryKey: "CARTO_API_KEY"
    ) as? String else {
      fatalError("CARTO_API_KEY not found in Info.plist")
    }

    return key
  }
}
