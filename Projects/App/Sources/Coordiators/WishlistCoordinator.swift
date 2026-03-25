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

enum WishlistFlowEvent {
  case moveToWishlistTab
  case moveToJourneyTab
}

@MainActor
final class WishlistCoordinator: Coordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let navigationController: UINavigationController

  private var onBookItemSelected: ((BookInfo) -> Void)?
  private var onDepartureAirportSelected: ((AirportInfo) -> Void)?
  private var onDestinationAirportSelected: ((AirportInfo) -> Void)?

  private let registerWishlistBuilder: RegisterWishlistBuildable
  private let wishTicketBuilder: WishTicketBuildable
  private let checkInWishTicketBuilder: CheckInWishTicketBuildable
  private let searchBuilder: SearchBuildable

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
