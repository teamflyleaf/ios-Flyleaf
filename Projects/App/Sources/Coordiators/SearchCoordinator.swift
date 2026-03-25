//
//  SearchCoordinator.swift
//  App
//
//  Created by 여성일 on 3/25/26.
//

import Core
import SearchInterface
import UIKit

@MainActor
final class SearchCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  var rootViewController: UIViewController?
  
  private let searchBuilder: SearchBuildable
  
  private var onBookSelected: ((BookInfo) -> Void)?
  private var onDepartureAirportSelected: ((AirportInfo) -> Void)?
  private var onArrivalAirportSelected: ((AirportInfo) -> Void)?
  
  init(
    navigationController: UINavigationController,
    searchBuilder: SearchBuildable
  ) {
    self.navigationController = navigationController
    self.searchBuilder = searchBuilder
  }
  
  func start() { }
}

// MARK: - Public
extension SearchCoordinator {
  func startBookSearch(
    onSelected: @escaping (BookInfo) -> Void
  ) {
    onBookSelected = onSelected
    showBookSearch()
  }
  
  func startDepartureAirportSearch(
    onSelected: @escaping (AirportInfo) -> Void
  ) {
    onDepartureAirportSelected = onSelected
    showDepartureAirportSearch()
  }
  
  func startArrivalAirportSearch(
    onSelected: @escaping (AirportInfo) -> Void
  ) {
    onArrivalAirportSelected = onSelected
    showArrivalAirportSearch()
  }
}

// MARK: - Private
private extension SearchCoordinator {
  func showBookSearch() {
    let searchVC = searchBuilder.build(
      type: .book,
      onTapBack: { [weak self] in
        self?.finishByPop()
      },
      onTapBookItem: { [weak self] item in
        self?.onBookSelected?(item)
        self?.onBookSelected = nil
        self?.finishByPop()
      },
      onTapAirportItem: nil
    )
    
    rootViewController = searchVC
    navigationController.pushViewController(searchVC, animated: true)
  }
  
  func showDepartureAirportSearch() {
    let searchVC = searchBuilder.build(
      type: .departureAirport,
      onTapBack: { [weak self] in
        self?.finishByPop()
      },
      onTapBookItem: nil,
      onTapAirportItem: { [weak self] item in
        self?.onDepartureAirportSelected?(item)
        self?.onDepartureAirportSelected = nil
        self?.finishByPop()
      }
    )
    
    rootViewController = searchVC
    navigationController.pushViewController(searchVC, animated: true)
  }
  
  func showArrivalAirportSearch() {
    let searchVC = searchBuilder.build(
      type: .arrivalAirport,
      onTapBack: { [weak self] in
        self?.finishByPop()
      },
      onTapBookItem: nil,
      onTapAirportItem: { [weak self] item in
        self?.onArrivalAirportSelected?(item)
        self?.onArrivalAirportSelected = nil
        self?.finishByPop()
      }
    )
    
    rootViewController = searchVC
    navigationController.pushViewController(searchVC, animated: true)
  }
  
  func finishByPop() {
    navigationController.popViewController(animated: true)
  }
}
