//
//  SearchBuildable.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

import UIKit

public protocol SearchBuildable {
  func build(
    type: SearchType,
    onTapBack: @escaping () -> Void
  ) -> UIViewController
}
