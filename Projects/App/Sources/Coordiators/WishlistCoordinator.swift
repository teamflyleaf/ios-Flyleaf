//
//  WishlistCoordinator.swift
//  App
//
//  Created by 여성일 on 3/25/26.
//

import Core
import SearchInterface
import UIKit
import WishlistInterface

@MainActor
final class WishlistCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController
  
  private let registerWishlistBuilder: RegisterWishlistBuildable
  private let wishTicketBuilder: WishTicketBuildable
  private let checkInWishTicketBuilder: CheckInWishTicketBuildable
  private let searchBuilder: SearchBuildable
  
  enum WishlistFlowEvent {
    case moveToWishlistTab
    case moveToJourneyTab
  }
  
  var onFlowEvent: ((WishlistFlowEvent) -> Void)?
  
  init(
    navigationController: UINavigationController,
    registerWishlistBuilder: RegisterWishlistBuildable,
    wishTicketBuilder: WishTicketBuildable,
    checkInWishTicketBuilder: CheckInWishTicketBuildable,
    searchBuilder: SearchBuildable
  ) {
    self.navigationController = navigationController
    self.registerWishlistBuilder = registerWishlistBuilder
    self.wishTicketBuilder = wishTicketBuilder
    self.checkInWishTicketBuilder = checkInWishTicketBuilder
    self.searchBuilder = searchBuilder
  }
  
  func start() {
    showRegisterWishlist()
  }
}

// MARK: - Wishlist Flow
private extension WishlistCoordinator {
  func showRegisterWishlist() {
    let registerWishlistVC = registerWishlistBuilder.build(
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
      onTapCreateTicket: { [weak self] book, departure, destination, reason in
        self?.showWishTicket(
          book: book,
          departure: departure,
          destination: destination,
          reason: reason
        )
      }
    )
    
    navigationController.pushViewController(registerWishlistVC, animated: true)
  }
  
  func showWishTicket(
    book: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    reason: String
  ) {
    let payload = WishlistTicketPayload(
      book: book,
      departure: departure,
      destination: destination,
      reason: reason
    )
    
    let ticketVC = wishTicketBuilder.build(
      payload: payload,
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onUploadCompleted: { [weak self] in
        self?.onFlowEvent?(.moveToWishlistTab)
        self?.finishFlowToRoot()
      }
    )
    
    navigationController.pushViewController(ticketVC, animated: true)
  }
  
  func showCheckInWishTicket(
    journey: ReadingJourney
  ) {
    let viewController = checkInWishTicketBuilder.build(
      journey: journey,
      onTapBack: { [weak self] in
        self?.pop(animated: true)
      },
      onUploadCompleted: { [weak self] in
        self?.onFlowEvent?(.moveToJourneyTab)
        self?.finishFlowToRoot()
      }
    )
    
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: - Search Flow
private extension WishlistCoordinator {
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

// MARK: - Public
extension WishlistCoordinator {
  func startCheckInFlow(journey: ReadingJourney) {
    showCheckInWishTicket(journey: journey)
  }
}

// MARK: - Finish
private extension WishlistCoordinator {
  func finishFlow() {
    navigationController.popViewController(animated: true)
    parentCoordinator?.childDidFinish(self)
  }
  
  func finishFlowToRoot() {
    navigationController.popToRootViewController(animated: false)
    parentCoordinator?.childDidFinish(self)
  }
}
