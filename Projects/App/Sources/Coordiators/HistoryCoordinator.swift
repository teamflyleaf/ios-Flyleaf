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
        self?.startBookSearch(onSelected: onSelected)
      },
      onTapSelectDepartureButton: { [weak self] onSelected in
        self?.startDepartureAirportSearch(onSelected: onSelected)
      },
      onTapSelectDestinationButton: { [weak self] onSelected in
        self?.startArrivalAirportSearch(onSelected: onSelected)
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
  func makeSearchCoordinator() -> SearchCoordinator {
    let coordinator = SearchCoordinator(
      navigationController: navigationController,
      searchBuilder: searchBuilder
    )
    coordinator.parentCoordinator = self
    childCoordinators.append(coordinator)
    return coordinator
  }
  
  func startBookSearch(onSelected: @escaping (BookInfo) -> Void) {
    makeSearchCoordinator().startBookSearch(onSelected: onSelected)
  }
  
  func startDepartureAirportSearch(onSelected: @escaping (AirportInfo) -> Void) {
    makeSearchCoordinator().startDepartureAirportSearch(onSelected: onSelected)
  }
  
  func startArrivalAirportSearch(onSelected: @escaping (AirportInfo) -> Void) {
    makeSearchCoordinator().startArrivalAirportSearch(onSelected: onSelected)
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
