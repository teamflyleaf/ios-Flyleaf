//
//  ThemeManager.swift
//  DesignSystem
//
//  Created by 여성일 on 6/28/26.
//

import UIKit

public enum ThemeManager {
  private static let key = "selectedThemeMode"

  public static var currentTheme: ThemeMode {
    get {
      let raw = UserDefaults.standard.string(forKey: key) ?? ThemeMode.system.rawValue
      return ThemeMode(rawValue: raw) ?? .system
    }
    set {
      UserDefaults.standard.set(newValue.rawValue, forKey: key)
    }
  }

  public static func apply(window: UIWindow?) {
    switch currentTheme {
    case .light:   window?.overrideUserInterfaceStyle = .light
    case .dark:    window?.overrideUserInterfaceStyle = .dark
    case .system:  window?.overrideUserInterfaceStyle = .unspecified
    }
  }

  public static func setTheme(_ mode: ThemeMode, window: UIWindow?) {
    currentTheme = mode
    apply(window: window)
  }
}
