//
//  MockTooltipService.swift
//  TooltipTesting
//
//  Created by 여성일 on now.
//

import Foundation
import TooltipInterface

public final class MockTooltipService: TooltipServicing {
  public init() {}
  
  public func shouldShowTooltip(for key: TooltipKey) -> Bool {
    fatalError()
  }
  
  public func markTooltipShown(for key: TooltipKey) {
    fatalError()
  }
}
