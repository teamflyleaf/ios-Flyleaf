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
    onRoute: @escaping (SearchRoute) -> Void
  ) -> UIViewController {
    let bookSearchService = AladinBookSearchService()
    let airportSearchService = AirportSearchService(
      bundle: Bundle(for: AirportSearchService.self)
    )
    let recentSearchStorage = RecentSearchStorage()

    try? airportSearchService.loadAirports()
    
    let viewModel = SearchViewModel(
      type: type,
      bookSearchService: bookSearchService,
      airportSearchService: airportSearchService,
      recentSearchStorage: recentSearchStorage
    )

    let viewController = SearchViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    return viewController
  }
}
