//
//  RegisterCheckView.swift
//  Wishlist
//
//  Created by 여성일 on 3/16/26.
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
  
  private let reasonCheckTitleLabel = UILabel().then {
    $0.text = "읽고 싶은 이유"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let reasonLabel = NeutralPaddingLabel().then {
    $0.font = .c2
    $0.textColor = .n0
    $0.backgroundColor = .n20
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
    $0.numberOfLines = 0
  }
  
  private let actionButtonView = StepActionButtonView()
  
  override func configureUI() {
    [
      headerTitleLabel,
      headerSubTitleLabel,
      routeBookInfoView,
      reasonCheckTitleLabel,
      reasonLabel,
      actionButtonView
    ].forEach {
      addSubview($0)
    }
    
    backgroundColor = .clear
    bind()
  }
  
  override func setupLayout() {
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
    
    reasonCheckTitleLabel.snp.makeConstraints {
      $0.top.equalTo(routeBookInfoView.snp.bottom).offset(20)
      $0.leading.equalToSuperview()
    }
    
    reasonLabel.snp.makeConstraints {
      $0.top.equalTo(reasonCheckTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    actionButtonView.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  func configure(
    bookItem: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    reason: String
  ) {
    routeBookInfoView.configure(
      bookItem: bookItem,
      departure: departure,
      destination: destination
    )
    reasonLabel.text = reason
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

