//
//  RegisterCheckView.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

final class RegisterCheckView: BaseView {
  var onTapPrev: (() -> Void)?
  var onTapNext: (() -> Void)?
  
  // MARK: - UI
  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
  }
  
  private let contentView = UIView()
  
  private let headerTitleLabel = UILabel().then {
    $0.font = .h3
    $0.text = "이 여행이 맞을까요?"
    $0.textColor = .n0
  }
  
  private let headerSubTitleLabel = UILabel().then {
    $0.font = .b1_m
    $0.text = "책과 여행 경로를 확인해주세요"
    $0.textColor = .gray0
  }
  
  private let routeBookInfoView = RouteBookInfoView()
  
  private let startSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "시작일"
    $0.textColor = .n0
  }
  
  private let startDayLabel = NeutralPaddingLabel().then {
    $0.font = .c2
    $0.textColor = .n0
    $0.backgroundColor = .n20
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
    $0.numberOfLines = 0
  }
  
  private let finishSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "종료일"
    $0.textColor = .n0
  }
  
  private let finishDayLabel = NeutralPaddingLabel().then {
    $0.font = .c2
    $0.textColor = .n0
    $0.backgroundColor = .n20
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
    $0.numberOfLines = 0
  }
  
  private let reviewSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "감상평"
    $0.textColor = .n0
  }
  
  private let reviewLabel = NeutralPaddingLabel().then {
    $0.font = .c2
    $0.textColor = .n0
    $0.backgroundColor = .n20
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
    $0.numberOfLines = 0
  }
  
  private let actionButtonView = StepActionButtonView()
  
  override func configureUI() {
    addSubview(scrollView)
    addSubview(actionButtonView)
    scrollView.addSubview(contentView)
    
    [
      headerTitleLabel,
      headerSubTitleLabel,
      routeBookInfoView,
      startSectionTitleLabel,
      startDayLabel,
      finishSectionTitleLabel,
      finishDayLabel,
      reviewSectionTitleLabel,
      reviewLabel
    ].forEach {
      contentView.addSubview($0)
    }
    
    backgroundColor = .clear
    bind()
  }
  
  override func setupLayout() {
    actionButtonView.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
    }
    
    scrollView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(actionButtonView.snp.top).offset(-20)
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalTo(scrollView.frameLayoutGuide)
    }
    
    headerTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    headerSubTitleLabel.snp.makeConstraints {
      $0.top.equalTo(headerTitleLabel.snp.bottom).offset(4)
      $0.leading.equalToSuperview()
    }

    routeBookInfoView.snp.makeConstraints {
      $0.top.equalTo(headerSubTitleLabel.snp.bottom).offset(36)
      $0.centerX.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
    }
    
    startSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(routeBookInfoView.snp.bottom).offset(20)
      $0.leading.equalToSuperview()
    }
    
    startDayLabel.snp.makeConstraints {
      $0.top.equalTo(startSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    finishSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(startDayLabel.snp.bottom).offset(20)
      $0.leading.equalToSuperview()
    }
    
    finishDayLabel.snp.makeConstraints {
      $0.top.equalTo(finishSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    reviewSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(finishDayLabel.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
    }
    
    reviewLabel.snp.makeConstraints {
      $0.top.equalTo(reviewSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  func configure(
    bookItem: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    startDate: Date,
    finishDate: Date,
    review: String
  ) {
    routeBookInfoView.configure(
      bookItem: bookItem,
      departure: departure,
      destination: destination
    )
    startDayLabel.text = startDate.formattedDot
    finishDayLabel.text = finishDate.formattedDot
    reviewLabel.text = review
  }
  
  func setLoading(_ isLoading: Bool) {
    actionButtonView.isUserInteractionEnabled = !isLoading
  }
}

// MARK: - Private
private extension RegisterCheckView {
  func bind() {
    actionButtonView.configure(isNextEnabled: true)
    
    actionButtonView.onTapPrev = { [weak self] in
      self?.onTapPrev?()
    }
    
    actionButtonView.onTapNext = { [weak self] in
      self?.onTapNext?()
    }
  }
}
