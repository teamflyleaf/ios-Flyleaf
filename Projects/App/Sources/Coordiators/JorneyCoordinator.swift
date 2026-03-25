//
//  JorneyCoordinator.swift
//  App
//
//  Created by 여성일 on 3/25/26.
//

import Core
import JourneyInterface
import SearchInterface
import UIKit

@MainActor
final class JourneyCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  var rootViewController: UIViewController?
  
  private let registerJourneyBuilder: RegisterJourneyBuildable
  private let journeyTicketBuilder: JourneyTicketBuildable
  private let searchBuilder: SearchBuildable
  
  enum FlowEvent {
    case moveToJourneyTab
  }
  
  var onFlowEvent: ((FlowEvent) -> Void)?
  
  init(
    navigationController: UINavigationController,
    registerJourneyBuilder: RegisterJourneyBuildable,
    journeyTicketBuilder: JourneyTicketBuildable,
    searchBuilder: SearchBuildable
  ) {
    self.navigationController = navigationController
    self.registerJourneyBuilder = registerJourneyBuilder
    self.journeyTicketBuilder = journeyTicketBuilder
    self.searchBuilder = searchBuilder
  }
  
  func start() {
    showRegisterJourney()
  }
}

// MARK: - Journey Flow
private extension JourneyCoordinator {
  func showRegisterJourney() {
    let registerJourneyVC = registerJourneyBuilder.build(
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
          
        case .createTicket(let book, let departure, let destination, let startDate, let currentPage):
          self?.showJourneyTicket(
            book: book,
            departure: departure,
            destination: destination,
            startDate: startDate,
            currentPage: currentPage
          )
        }
      }
    )
    
    rootViewController = registerJourneyVC
    navigationController.pushViewController(registerJourneyVC, animated: true)
  }
  
  func showJourneyTicket(
    book: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    startDate: Date,
    currentPage: Int
  ) {
    let payload = JourneyPayload(
      book: book,
      startDate: startDate,
      currentPage: currentPage,
      departureAirport: departure,
      destinationAirport: destination
    )
    
    let ticketVC = journeyTicketBuilder.build(
      payload: payload,
      onRoute: { [weak self] route in
        switch route {
        case .back:
          self?.pop(animated: true)
        case .uploadCompleted:
          self?.onFlowEvent?(.moveToJourneyTab)
          self?.finishFlowToRoot()
        }
      }
    )
    
    navigationController.pushViewController(ticketVC, animated: true)
  }
}

// MARK: - Search Flow
private extension JourneyCoordinator {
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
private extension JourneyCoordinator {
  func finishFlow() {
    navigationController.popViewController(animated: true)
  }
  
  func finishFlowToRoot() {
    navigationController.popToRootViewController(animated: false)
    parentCoordinator?.childDidFinish(self)
  }
}
