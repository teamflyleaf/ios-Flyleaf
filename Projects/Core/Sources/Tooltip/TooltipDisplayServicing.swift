//
//  TooltipDisplayServicing.swift
//  Core
//
//  Created by 여성일 on 3/30/26.
//

public protocol TooltipDisplayServicing {
  func shouldShowTooltip(for key: TooltipKey) -> Bool
  func markTooltipShown(for key: TooltipKey)
}
