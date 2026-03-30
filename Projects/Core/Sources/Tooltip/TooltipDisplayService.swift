//
//  TooltipDisplayService.swift
//  Core
//
//  Created by 여성일 on 3/30/26.
//

import Foundation

/// 툴팁 노출 여부를 관리하는 서비스입니다.
///
/// `UserDefaults`를 기반으로 특정 툴팁이 이미 노출되었는지 여부를 저장하고,
/// 이후 재노출 여부를 판단합니다.
///
/// 주로 "최초 1회만 보여줘야 하는 UI(온보딩, 가이드 등)"에 사용됩니다.
///
/// ```swift
/// let service = TooltipDisplayService()
///
/// if service.shouldShowTooltip(for: .homeGuide) {
///   // 툴팁 표시
///   service.markTooltipShown(for: .homeGuide)
/// }
/// ```
public final class TooltipDisplayService: TooltipDisplayServicing {
  private let userDefaults: UserDefaults
  
  public init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  
  /// 해당 툴팁을 표시해야 하는지 여부를 반환합니다.
  ///
  /// - Parameter key: 툴팁을 식별하는 키입니다.
  /// - Returns: 아직 표시된 적이 없다면 `true`, 이미 표시되었다면 `false`
  public func shouldShowTooltip(for key: TooltipKey) -> Bool {
    !userDefaults.bool(forKey: key.rawValue)
  }
  
  /// 해당 툴팁이 이미 표시되었음을 기록합니다.
  ///
  /// 이후 동일한 키에 대해서는 `shouldShowTooltip`이 `false`를 반환합니다.
  ///
  /// - Parameter key: 툴팁을 식별하는 키입니다.
  public func markTooltipShown(for key: TooltipKey) {
    userDefaults.set(true, forKey: key.rawValue)
  }
}
