//
//  +Date.swift
//  DesignSystem
//
//  Created by 여성일 on 3/18/26.
//

import Foundation

public extension Date {
  var formattedDot: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.string(from: self)
  }
}
