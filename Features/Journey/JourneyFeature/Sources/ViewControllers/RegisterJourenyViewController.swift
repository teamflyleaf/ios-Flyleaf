//
//  RegisterJourenyViewController.swift
//  Journey
//
//  Created by 여성일 on 3/19/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit
import JourneyInterface

public final class RegisterJourenyViewController: BaseViewController {
  public var onRoute: ((RegisterJourneyRoute) -> Void)?
  
  private let viewModel: RegisterJourenyViewModel
  
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
  
  public init(viewModel: RegisterJourenyViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "읽고 있는 책")
  private let progressView = NeutralProgressView()
  private let dividerView = DividerView()
  private let registerJourneyBookView = RegisterJourneyBookView()
  private let selectRouteView = SelectRouteView()
  private let registerCheckView = RegisterCheckView()
  
  override public func configureUI() {
    [
      headerView,
      progressView,
      dividerView,
      registerJourneyBookView,
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
    
    registerJourneyBookView.snp.makeConstraints {
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
    bindRegisterJourneyBookView()
    bindSelectRouteView()
    bindRegisterCheckView()
    
    viewModel.onSelectedBookChanged = { [weak self] item in
      self?.registerJourneyBookView.configure(item)
    }
    
    viewModel.onSelectDepartureChanged = { [weak self] item in
      self?.selectRouteView.configureDeparture(item)
    }
    
    viewModel.onSelectDestinationChanged = { [weak self] item in
      self?.selectRouteView.configureDestination(item)
    }
    
    viewModel.onBookStepNextButtonEnabledChanged = { [weak self] isEnabled in
      self?.registerJourneyBookView.setNextButtonEnabled(isEnabled)
    }
    
    updateStepUI()
  }
}

// MARK: - Private
private extension RegisterJourenyViewController {
  func updateStepUI() {
    switch currentStep {
    case .book:
      progressView.configure(step: .book)
      registerJourneyBookView.isHidden = false
      selectRouteView.isHidden = true
      registerCheckView.isHidden = true
      
    case .route:
      progressView.configure(step: .route)
      registerJourneyBookView.isHidden = true
      selectRouteView.isHidden = false
      registerCheckView.isHidden = true
      
    case .check:
      progressView.configure(step: .check)
      registerJourneyBookView.isHidden = true
      selectRouteView.isHidden = true
      registerCheckView.isHidden = false
      
      renderRegisterCheckView()
    }
  }
  
  func renderRegisterCheckView() {
    guard
      let book = self.viewModel.selectedBook,
      let depature = self.viewModel.departureAirport,
      let destination = self.viewModel.destinationAirport,
      let startDate = self.viewModel.startDate,
      let page = self.viewModel.currentPage
    else { return }
    
    registerCheckView.configure(
      bookItem: book,
      departure: depature,
      destination: destination,
      startDate: startDate,
      page: page
    )
  }
  
  func bindHeaderView() {
    headerView.onTapBack = { [weak self] in
      self?.onRoute?(.back)
    }
  }
  
  func bindRegisterJourneyBookView() {
    registerJourneyBookView.onRegisterBookSearchTap = { [weak self] in
      self?.onRoute?(.bookSearch { [weak self] item in
        self?.viewModel.updateSelectedBook(item)
      })
    }
    
    registerJourneyBookView.onStartDateChanged = { [weak self] date in
      self?.viewModel.updateStartDate(date)
    }
    
    registerJourneyBookView.onReadingPageChanged = { [weak self] page in
      self?.viewModel.updateCurrentPage(page)
    }
    
    registerJourneyBookView.onTapNext = { [weak self] in
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
      self?.onRoute?(.departureSearch { [weak self] item in
        guard let self else { return }
        
        if self.viewModel.isSameAsDestination(item) {
          self.presentAlert(
            title: "선택 불가",
            message: "출발지와 도착지는 같을 수 없습니다."
          )
          return
        }
        
        self.viewModel.updateDepartureAirport(item)
      })
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
      
      self.onRoute?(.destinationSearch { [weak self] item in
        guard let self else { return }
        
        if self.viewModel.isSameAsDeparture(item) {
          self.presentAlert(
            title: "선택 불가",
            message: "출발지와 도착지는 같을 수 없습니다."
          )
          return
        }
        
        self.viewModel.updateDestinationAirport(item)
      })
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
        let destination = self.viewModel.destinationAirport,
        let startDate = self.viewModel.startDate,
        let currentPage = self.viewModel.currentPage
      else { return }
      
      self.onRoute?(
        .createTicket(
          book,
          depature,
          destination,
          startDate,
          currentPage
        )
      )
    }
  }
}
