//
//  SearchBuilder.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

import Core
import AirportSearchInterface
import BookSearchInterface
import SearchInterface
import SearchHistoryInterface
import UIKit

public final class SearchBuilder: SearchBuildable {
  let airportSearchService: AirportSearchServicing
  let bookSearchService: BookSearchServicing
  let searchHistoryService: SearchHistoryServicing
  
  public init(
    airportSearchService: AirportSearchServicing,
    bookSearchService: BookSearchServicing,
    searchHistoryService: SearchHistoryServicing
  ) {
    self.airportSearchService = airportSearchService
    self.bookSearchService = bookSearchService
    self.searchHistoryService = searchHistoryService
  }

  public func build(
    type: SearchType,
    onRoute: @escaping (SearchRoute) -> Void
  ) -> UIViewController {
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
