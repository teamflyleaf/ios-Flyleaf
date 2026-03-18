//
//  RegisterHistoryBuildable.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import UIKit

public protocol RegisterHistoryBuildable {
  func build(
    onTapBack: (() -> Void)?,
    onTapRegisterBookSearch: ((@escaping (BookInfo) -> Void) -> Void)?,
    onTapSelectDepartureButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onTapSelectDestinationButton: ((@escaping (AirportInfo) -> Void) -> Void)?,
    onUploadCompleted: @escaping () -> Void
  ) -> UIViewController
}
