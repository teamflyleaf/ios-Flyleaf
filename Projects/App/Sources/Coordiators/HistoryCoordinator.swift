//
//  HistoryCoordinator.swift
//  App
//
//  Created by 여성일 on 3/25/26.
//


import Core
import HistoryInterface
import SearchInterface
import UIKit

@MainActor
final class HistoryCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  
  private var onBookItemSelected: ((BookInfo) -> Void)?
  private var onDepartureAirportSelected: ((AirportInfo) -> Void)?
  private var onDestinationAirportSelected: ((AirportInfo) -> Void)?
  
  private let registerHistoryBuilder: RegisterHistoryBuildable
  private let detailHistoryBuilder: DetailHistoryBuildable
  private let searchBuilder: SearchBuildable
  
  enum FlowEvent {
    case moveToHistoryTab
  }
  
  var onFlowEvent: ((FlowEvent) -> Void)?
  
  init(
    navigationController: UINavigationController,
    registerHistoryBuilder: RegisterHistoryBuildable,
    detailHistoryBuilder: DetailHistoryBuildable,
    searchBuilder: SearchBuildable
  ) {
    self.navigationController = navigationController
    self.registerHistoryBuilder = registerHistoryBuilder
    self.detailHistoryBuilder = detailHistoryBuilder
    self.searchBuilder = searchBuilder
  }
  
  func start() {
    showRegisterHistory()
  }
  
  func startDetailFlow(journey: ReadingJourney) {
    showDetailHistory(journey: journey)
  }
}

// MARK: - History Flow
private extension HistoryCoordinator {
  func showRegisterHistory() {
    let registerHistoryVC = registerHistoryBuilder.build(
      onTapBack: { [weak self] in
        self?.finishFlow()
      },
      onTapRegisterBookSearch: { [weak self] onSelected in
        self?.onBookItemSelected = onSelected
        self?.showBookSearch()
      },
      onTapSelectDepartureButton: { [weak self] onSelected in
        self?.onDepartureAirportSelected = onSelected
        self?.showDepartureAirportSearch()
      },
      onTapSelectDestinationButton: { [weak self] onSelected in
        self?.onDestinationAirportSelected = onSelected
        self?.showArrivalAirportSearch()
      },
      onUploadCompleted: { [weak self] in
        self?.onFlowEvent?(.moveToHistoryTab)
        self?.finishFlowToRoot()
      }
    )
    
    navigationController.pushViewController(registerHistoryVC, animated: true)
  }
  
  func showDetailHistory(journey: ReadingJourney) {
    let vc = detailHistoryBuilder.build(
      journey: journey,
      onTapBack: { [weak self] in
        self?.finishFlow()
      }
    )
    
    navigationController.pushViewController(vc, animated: true)
  }
}

// MARK: - Search Flow
private extension HistoryCoordinator {
  func showBookSearch() {
    let searchVC = searchBuilder.build(
      type: .book,
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onTapBookItem: { [weak self] item in
        self?.pop(animated: true)
        self?.onBookItemSelected?(item)
        self?.onBookItemSelected = nil
      },
      onTapAirportItem: nil
    )
    
    navigationController.pushViewController(searchVC, animated: true)
  }
  
  func showDepartureAirportSearch() {
    let searchVC = searchBuilder.build(
      type: .departureAirport,
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onTapBookItem: nil,
      onTapAirportItem: { [weak self] item in
        self?.pop(animated: true)
        self?.onDepartureAirportSelected?(item)
        self?.onDepartureAirportSelected = nil
      }
    )
    
    navigationController.pushViewController(searchVC, animated: true)
  }
  
  func showArrivalAirportSearch() {
    let searchVC = searchBuilder.build(
      type: .arrivalAirport,
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onTapBookItem: nil,
      onTapAirportItem: { [weak self] item in
        self?.pop(animated: true)
        self?.onDestinationAirportSelected?(item)
        self?.onDestinationAirportSelected = nil
      }
    )
    
    navigationController.pushViewController(searchVC, animated: true)
  }
}

// MARK: - Finish
private extension HistoryCoordinator {
  func finishFlow() {
    navigationController.popViewController(animated: true)
    parentCoordinator?.childDidFinish(self)
  }
  
  func finishFlowToRoot() {
    navigationController.popToRootViewController(animated: false)
    parentCoordinator?.childDidFinish(self)
  }
}
