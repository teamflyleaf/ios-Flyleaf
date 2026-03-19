//
//  +Date.swift
//  DesignSystem
//
//  Created by 여성일 on 3/18/26.
//

import Foundation

public extension Date {
  
  /// 날짜를 `"yyyy.MM.dd"` 형식의 문자열로 변환합니다.
  /// 주로 UI에서 날짜를 간결하고 일관된 포맷으로 표시할 때 사용됩니다.
  ///
  /// ```swift
  /// let date = Date(timeIntervalSince1970: 1710892800)
  /// print(date.formattedDot) // "2024.03.20"
  /// ```
  ///
  /// - Returns: `"yyyy.MM.dd"` 형식으로 포맷된 날짜 문자열
  ///
  /// - Note:
  ///   - 로케일(locale)이나 타임존(timeZone)은 기본 시스템 설정을 따릅니다.
  var formattedDot: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.string(from: self)
  }
}
