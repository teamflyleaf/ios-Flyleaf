//
//  SearchBuilder.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

import Core
import SearchInterface
import UIKit

public final class SearchBuilder: SearchBuildable {
  public init() {}

  public func build(
    type: SearchType,
    onTapBack: @escaping () -> Void
  ) -> UIViewController {
    let bookSearchService = AladinBookSearchService()
    let viewModel = SearchViewModel(type: type, bookSearchService: bookSearchService)
    let viewController = SearchViewController(viewModel: viewModel)
    viewController.onTapBack = onTapBack
    return viewController
  }
}
