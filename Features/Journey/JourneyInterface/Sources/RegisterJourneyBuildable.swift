//
//  RegisterJourneyBuildable.swift
//  Journey
//
//  Created by 여성일 on 3/19/26.
//

import Core
import UIKit

public protocol RegisterJourneyBuildable {
  func build(
    onTapBack: (() -> Void)?,
    onTapRegisterBookSearch: ((@escaping (BookInfo) -> Void) -> Void)?,
    onTapSelectDepartureButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onTapSelectDestinationButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onTapCreateTicket: ((BookInfo, AirportInfo, AirportInfo, Date, Int) -> Void)?
  ) -> UIViewController
}
