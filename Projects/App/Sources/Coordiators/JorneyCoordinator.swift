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
  
  private var onBookItemSelected: ((BookInfo) -> Void)?
  private var onDepartureAirportSelected: ((AirportInfo) -> Void)?
  private var onDestinationAirportSelected: ((AirportInfo) -> Void)?
  
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
private extension JourneyCoordinator {
  func finishFlow() {
    navigationController.popViewController(animated: true)
    parentCoordinator?.childDidFinish(self)
  }
  
  func finishFlowToRoot() {
    navigationController.popToRootViewController(animated: false)
    parentCoordinator?.childDidFinish(self)
  }
}
