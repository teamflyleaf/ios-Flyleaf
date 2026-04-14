//
//  SearchBuilder.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

import Core
import AirportSearchInterface
import AirportSearchImplementation
import BookSearchInterface
import BookSearchImplementation
import SearchInterface
import SearchHistoryInterface
import UIKit

public final class SearchBuilder: SearchBuildable {
  let searchHistoryService: SearchHistoryServicing
  
  public init(
    searchHistoryService: SearchHistoryServicing
  ) {
    self.searchHistoryService = searchHistoryService
  }

  public func build(
    type: SearchType,
    onRoute: @escaping (SearchRoute) -> Void
  ) -> UIViewController {
    let bookSearchService = BookSearchService()
    let airportSearchService = AirportSearchService(
      bundle: Bundle(for: AirportSearchService.self)
    )
    try? airportSearchService.loadAirports()
    
    let viewModel = SearchViewModel(
      type: type,
      bookSearchService: bookSearchService,
      airportSearchService: airportSearchService,
      searchHistoryService: searchHistoryService
    )

    let viewController = SearchViewController(viewModel: viewModel)
    viewController.onRoute = onRoute
    return viewController
  }
}
