//
//  +Int.swift
//  DesignSystem
//
//  Created by 여성일 on 3/17/26.
//

import Foundation

public extension Int {
  /// 정수를 1,000 단위 콤마가 포함된 문자열로 변환합니다.
  /// ```swift
  /// let value = 12345
  /// print(value.formattedWithComma) // "12,345"
  /// ```
  /// - Returns: 3자리마다 콤마(,)가 포함된 문자열
  var formattedWithComma: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
  }
}
