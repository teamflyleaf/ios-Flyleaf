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
      onTapCreateTicket: { [weak self] book, departure, destination, startDate, currentPage in
        self?.showJourneyTicket(
          book: book,
          departure: departure,
          destination: destination,
          startDate: startDate,
          currentPage: currentPage
        )
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
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onUploadCompleted: { [weak self] in
        self?.onFlowEvent?(.moveToJourneyTab)
        self?.finishFlowToRoot()
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
