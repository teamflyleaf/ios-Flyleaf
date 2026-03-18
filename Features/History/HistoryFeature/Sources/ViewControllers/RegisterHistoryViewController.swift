//
//  RegisterHistoryViewController.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

public final class RegisterHistoryViewController: BaseViewController {
  public var onTapBack: (() -> Void)?
  public var onTapRegisterBookSearch: ((@escaping (BookInfo) -> Void) -> Void)?
  public var onTapSelectDepartureButton: ((@escaping (AirportInfo) -> Void) -> Void)?
  public var onTapSelectDestinationButton: ((@escaping (AirportInfo) -> Void) -> Void)?
  public var onUploadCompleted: (() -> Void)?
  
  private let viewModel: RegisterHistoryViewModel
  
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
  
  public init(viewModel: RegisterHistoryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "다 읽은 책")
  private let progressView = NeutralProgressView()
  private let dividerView = DividerView()
  private let registerHistoryBookView = RegisterHistoryBookView()
  private let selectRouteView = SelectRouteView()
  private let registerCheckView = RegisterCheckView()
  
  override public func configureUI() {
    [
      headerView,
      progressView,
      dividerView,
      registerHistoryBookView,
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
    
    registerHistoryBookView.snp.makeConstraints {
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
    bindRegisterHistoryView()
    bindSelectRouteView()
    bindRegisterCheckView()
    
    viewModel.onSelectedBookChanged = { [weak self] item in
      self?.registerHistoryBookView.configure(item)
    }
    
    viewModel.onSelectDepartureChanged = { [weak self] item in
      self?.selectRouteView.configureDeparture(item)
    }
    
    viewModel.onSelectDestinationChanged = { [weak self] item in
      self?.selectRouteView.configureDestination(item)
    }
    
    viewModel.onBookStepNextButtonEnabledChanged = { [weak self] isEnabled in
      self?.registerHistoryBookView.setNextButtonEnabled(isEnabled)
    }
    
    viewModel.onUploadSuccess = { [weak self] _ in
      DispatchQueue.main.async {
        self?.onUploadCompleted?()
      }
    }
    
    viewModel.onUploadStateChanged = { [weak self] isLoading in
      DispatchQueue.main.async {
        self?.registerCheckView.setLoading(isLoading)
        self?.headerView.isUserInteractionEnabled = !isLoading
      }
    }
    
    viewModel.onError = { [weak self] message in
      DispatchQueue.main.async {
        self?.presentAlert(title: "저장 실패", message: message)
      }
    }
    
    updateStepUI()
  }
}

// MARK: - Private
private extension RegisterHistoryViewController {
  func updateStepUI() {
    switch currentStep {
    case .book:
      progressView.configure(step: .book)
      registerHistoryBookView.isHidden = false
      selectRouteView.isHidden = true
      registerCheckView.isHidden = true
      
    case .route:
      progressView.configure(step: .route)
      registerHistoryBookView.isHidden = true
      selectRouteView.isHidden = false
      registerCheckView.isHidden = true
      
    case .check:
      progressView.configure(step: .check)
      registerHistoryBookView.isHidden = true
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
      let finishDate = self.viewModel.finishDate
    else { return }
    
    let review = self.viewModel.reviewText
    
    
    registerCheckView.configure(
      bookItem: book,
      departure: depature,
      destination: destination,
      startDate: startDate,
      finishDate: finishDate,
      review: review
    )
  }
  
  func bindHeaderView() {
    headerView.onTapBack = { [weak self] in
      self?.onTapBack?()
    }
  }
  
  func bindRegisterHistoryView() {
    registerHistoryBookView.onRegisterBookSearchTap = { [weak self] in
      self?.onTapRegisterBookSearch? { [weak self] item in
        self?.viewModel.updateSelectedBook(item)
      }
    }
    
    registerHistoryBookView.onReviewTextChanged = { [weak self] text in
      self?.viewModel.updateReviewText(text)
    }
    
    registerHistoryBookView.onStartDateChanged = { [weak self] date in
      self?.viewModel.updateStartDate(date)
    }
    
    registerHistoryBookView.onFinishDateChanged = { [weak self] date in
      self?.viewModel.updateFinishDate(date)
    }
    
    registerHistoryBookView.onTapNext = { [weak self] in
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
      Task {
        await self?.viewModel.uploadReadingJourney()
      }
    }
  }
}
