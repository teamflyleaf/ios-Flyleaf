//
//  DetailHistoryViewController.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit
import HistoryInterface

public final class DetailHistoryViewController: BaseViewController {
  public var onRoute: ((DetailHistoryRoute) -> Void)?
  
  private let viewModel: DetailHistoryViewModel
  
  public init(viewModel: DetailHistoryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "기록")
  private let dividerView = DividerView()
  private let detailHistoryView = DetailHistoryView()
  
  public override func configureUI() {
    [
      headerView,
      dividerView,
      detailHistoryView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  public override func setupLayout() {
    headerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.width.equalToSuperview()
    }
    
    dividerView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
    }
    
    detailHistoryView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
  }
  
  public override func bind() {
    bindDetailHistoryView()
    
    headerView.onTapBack = { [weak self] in
      guard let self else { return }
      self.view.endEditing(true)
      self.onRoute?(.back)
    }
    
    viewModel.onJourneyChanged = { [weak self] journey in
      DispatchQueue.main.async {
        self?.detailHistoryView.configure(journey)
      }
    }
    
    viewModel.onError = { [weak self] message in
      DispatchQueue.main.async {
        guard let self else { return }
        self.presentAlert(title: "수정 실패", message: message)
        self.detailHistoryView.configure(self.viewModel.journey)
      }
    }
  }
}

// MARK: - Private
private extension DetailHistoryViewController {
  func bindDetailHistoryView() {
    detailHistoryView.configure(viewModel.journey)
    
    detailHistoryView.onStartDateChanged = { [weak self] startDate in
      guard let self else { return }
      
      let finishDate = self.viewModel.journey.finishedAt ?? startDate
      
      Task {
        await self.viewModel.updateFinishedJourneyDates(
          startDate: startDate,
          finishDate: finishDate
        )
      }
    }
    
    detailHistoryView.onFinishDateChanged = { [weak self] finishDate in
      guard let self else { return }
      
      let startDate = self.viewModel.journey.startedAt ?? finishDate
      
      Task {
        await self.viewModel.updateFinishedJourneyDates(
          startDate: startDate,
          finishDate: finishDate
        )
      }
    }
    
    detailHistoryView.onTapReview = { [weak self] in
      self?.presentReviewEditSheet()
    }
  }
  
  func presentReviewEditSheet() {
    let vc = ReviewWriteViewController(
      book: viewModel.journey.book,
      existingReview: viewModel.journey.review
    )
    
    vc.onTapSave = { [weak self] review in
      Task {
        await self?.viewModel.updateFinishedJourneyReview(review)
      }
    }
    
    if let sheet = vc.sheetPresentationController {
      sheet.detents = [
        .custom { _ in 460 }
      ]
      sheet.preferredCornerRadius = 24
    }
    
    present(vc, animated: true)
  }
}
