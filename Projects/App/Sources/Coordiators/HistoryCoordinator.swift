//
//  HistoryCoordinator.swift
//  App
//
//  Created by 여성일 on 3/25/26.
//


import Core
import HistoryInterface
import SearchInterface
import ReadingJourneyInterface
import UIKit

@MainActor
final class HistoryCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  var rootViewController: UIViewController?
  
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
      onRoute: { [weak self] route in
        switch route {
        case .back:
          self?.finishFlow()
          
        case .bookSearch(let onSelected):
          self?.startBookSearch(onSelected: onSelected)
          
        case .departureSearch(let onSelected):
          self?.startDepartureAirportSearch(onSelected: onSelected)
          
        case .destinationSearch(let onSelected):
          self?.startArrivalAirportSearch(onSelected: onSelected)
          
        case .uploadCompleted:
          self?.onFlowEvent?(.moveToHistoryTab)
          self?.finishFlowToRoot()
        }
      }
    )
    
    rootViewController = registerHistoryVC
    navigationController.pushViewController(registerHistoryVC, animated: true)
  }
  
  func showDetailHistory(journey: ReadingJourney) {
    let vc = detailHistoryBuilder.build(
      journey: journey,
      onRoute: { [weak self] route in
        switch route {
        case .back:
          self?.finishFlow()
        }
      }
    )
    
    rootViewController = vc
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
  }
  
  func finishFlowToRoot() {
    navigationController.popToRootViewController(animated: false)
    parentCoordinator?.childDidFinish(self)
  }
}
