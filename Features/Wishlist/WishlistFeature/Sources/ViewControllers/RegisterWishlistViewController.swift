//
//  RegisterWishlistViewController.swift
//  Wishlist
//
//  Created by 여성일 on 3/13/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

public final class RegisterWishlistViewController: BaseViewController {
  public var onTapBack: (() -> Void)?
  public var onTapRegisterBookSearch: ((@escaping (BookInfo) -> Void) -> Void)?
  public var onTapSelectDepartureButton: ((@escaping (AirportInfo) -> Void) -> Void)?
  public var onTapSelectDestinationButton: ((@escaping (AirportInfo) -> Void) -> Void)?
  public var onTapCreateTicket: ((BookInfo, AirportInfo, AirportInfo, String) -> Void)?
  
  private let viewModel: RegisterWishlistViewModel
  
  private enum Step {
    case book
    case route
    case check
  }
  
  private var currentStep: Step = .book {
    didSet {
      updateStepUI()
    }
  }
  
  public init(viewModel: RegisterWishlistViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "읽고 싶은 책")
  private let progressView = NeutralProgressView()
  private let dividerView = DividerView()
  private let registerWishBookView = RegisterWishBookView()
  private let selectRouteView = SelectRouteView()
  private let registerCheckView = RegisterCheckView()
  
  override public func configureUI() {
    [
      headerView,
      progressView,
      dividerView,
      registerWishBookView,
      selectRouteView,
      registerCheckView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  override public func setupLayout() {
    headerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.width.equalToSuperview()
    }
    
    progressView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    dividerView.snp.makeConstraints {
      $0.top.equalTo(progressView.snp.bottom).offset(18)
      $0.width.equalToSuperview()
    }
    
    registerWishBookView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
    
    selectRouteView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
    
    registerCheckView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
  }
  
  override public func bind() {
    bindHeaderView()
    bindSelectRouteView()
    bindRegisterCheckView()
    bindRegisterWishBookView()
    
    viewModel.onSelectedBookChanged = { [weak self] item in
      self?.registerWishBookView.configure(item)
    }
    
    viewModel.onSelectDepartureChanged = { [weak self] item in
      self?.selectRouteView.configureDeparture(item)
    }
    
    viewModel.onSelectDestinationChanged = { [weak self] item in
      self?.selectRouteView.configureDestination(item)
    }
    
    updateStepUI()
  }
}

// MARK: - Private
private extension RegisterWishlistViewController {
  func updateStepUI() {
    switch currentStep {
    case .book:
      progressView.configure(step: .book)
      registerWishBookView.isHidden = false
      selectRouteView.isHidden = true
      registerCheckView.isHidden = true
      
    case .route:
      progressView.configure(step: .route)
      registerWishBookView.isHidden = true
      selectRouteView.isHidden = false
      registerCheckView.isHidden = true
      
    case .check:
      progressView.configure(step: .check)
      registerWishBookView.isHidden = true
      selectRouteView.isHidden = true
      registerCheckView.isHidden = false
      
      renderRegisterCheckView()
    }
  }
  
  func renderRegisterCheckView() {
    guard
      let book = viewModel.selectedBook,
      let departure = viewModel.departureAirport,
      let destination = viewModel.destinationAirport
    else { return }
    
    registerCheckView.configure(
      bookItem: book,
      departure: departure,
      destination: destination,
      reason: viewModel.reasonText
    )
  }
  
  func bindHeaderView() {
    headerView.onTapBack = { [weak self] in
      self?.onTapBack?()
    }
  }
  
  func bindRegisterWishBookView() {
    registerWishBookView.onRegisterBookSearchTap = { [weak self] in
      self?.onTapRegisterBookSearch? { [weak self] item in
        self?.viewModel.updateSelectedBook(item)
      }
    }
    
    registerWishBookView.onReasonTextChanged = { [weak self] text in
      self?.viewModel.updateReasonText(text)
    }
    
    registerWishBookView.onTapNext = { [weak self] in
      self?.currentStep = .route
    }
  }
  
  func bindSelectRouteView() {
    selectRouteView.onTapPrev = { [weak self] in
      self?.currentStep = .book
    }
    
    selectRouteView.onTapNext = { [weak self] in
      self?.currentStep = .check
    }
    
    selectRouteView.onTapSelectDepartureButton = { [weak self] in
      self?.onTapSelectDepartureButton? { [weak self] item in
        guard let self else { return }

        if self.viewModel.isSameAsDestination(item) {
          self.presentAlert(
            title: "선택 불가",
            message: "출발지와 도착지는 같을 수 없습니다."
          )
          return
        }

        self.viewModel.updateDepartureAirport(item)
      }
    }
    
    selectRouteView.onTapSelectDestinationButton = { [weak self] in
      guard let self else { return }

      guard self.viewModel.canSelectDestinationAirport() else {
        self.presentAlert(
          title: "출발지 먼저 선택",
          message: "도착지를 선택하기 전에 출발지를 먼저 선택해주세요."
        )
        return
      }

      self.onTapSelectDestinationButton? { [weak self] item in
        guard let self else { return }

        if self.viewModel.isSameAsDeparture(item) {
          self.presentAlert(
            title: "선택 불가",
            message: "출발지와 도착지는 같을 수 없습니다."
          )
          return
        }

        self.viewModel.updateDestinationAirport(item)
      }
    }
  }
  
  func bindRegisterCheckView() {
    registerCheckView.onTapPrev = { [weak self] in
      self?.currentStep = .route
    }
    
    registerCheckView.onTapNext = { [weak self] in
      guard
        let self,
        let book = self.viewModel.selectedBook,
        let depature = self.viewModel.departureAirport,
        let destination = self.viewModel.destinationAirport
      else { return }
      
      self.onTapCreateTicket?(
        book,
        depature,
        destination,
        self.viewModel.reasonText
      )
    }
  }
}
