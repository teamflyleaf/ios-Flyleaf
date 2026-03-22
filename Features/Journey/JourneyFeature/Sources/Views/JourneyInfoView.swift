//
//  JourneyInfoView.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

final class JourneyInfoView: BaseView {
  var onTapFinish: (() -> Void)?
  var onPageChanged: ((Int) -> Void)?
  
  // MARK: - UI
  private let routeInfoView = RouteInfoView()
  
  private let startDateSectionTitleLabel = UILabel().then {
    $0.text = "시작일"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let startDateLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n20
    $0.textAlignment = .left
  }
  
  private let currentPageSectionTitleLabel = UILabel().then {
    $0.text = "읽은 페이지 수"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let currentPageLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n20
    $0.textAlignment = .left
    $0.isUserInteractionEnabled = true
  }
  
  private let currentPagePickerField = NeutralPagePickerField().then {
    $0.isHidden = true
  }
  
  private let distanceSectionTitleLabel = UILabel().then {
    $0.text = "여행 거리"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let distanceLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n20
    $0.textAlignment = .left
  }
  
  private let remainingDistanceSectionTitleLabel = UILabel().then {
    $0.text = "남은 거리"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let remainingDistanceLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n20
    $0.textAlignment = .left
  }
  
  private let finishButton = CTAButton(title: "독서 끝내기")
  
  override func configureUI() {
    [
      routeInfoView,
      startDateSectionTitleLabel,
      startDateLabel,
      currentPageSectionTitleLabel,
      currentPageLabel,
      currentPagePickerField,
      distanceSectionTitleLabel,
      distanceLabel,
      remainingDistanceSectionTitleLabel,
      remainingDistanceLabel,
      finishButton
    ].forEach {
      addSubview($0)
    }
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCurrentPage))
    currentPageLabel.addGestureRecognizer(tapGesture)
    
    currentPagePickerField.onPageChanged = { [weak self] page in
      self?.currentPageLabel.text = "\(page)p"
      self?.onPageChanged?(page)
    }
    
    bind()
  }
  
  override func setupLayout() {
    routeInfoView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
    }
    
    startDateSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(routeInfoView.snp.bottom).offset(40)
      $0.leading.equalToSuperview()
    }
    
    startDateLabel.snp.makeConstraints {
      $0.top.equalTo(startDateSectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
    }
    
    currentPageSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(startDateLabel.snp.bottom).offset(32)
      $0.leading.equalToSuperview()
    }
    
    currentPageLabel.snp.makeConstraints {
      $0.top.equalTo(currentPageSectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
    }
    
    // 화면에는 안 보이지만 picker inputView 용도로만 존재
    currentPagePickerField.snp.makeConstraints {
      $0.top.equalTo(currentPageLabel.snp.bottom)
      $0.leading.equalToSuperview()
      $0.width.height.equalTo(0)
    }
    
    distanceSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(currentPageLabel.snp.bottom).offset(32)
      $0.leading.equalToSuperview()
    }
    
    distanceLabel.snp.makeConstraints {
      $0.top.equalTo(distanceSectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
    }
    
    remainingDistanceSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(distanceLabel.snp.bottom).offset(32)
      $0.leading.equalToSuperview()
    }
    
    remainingDistanceLabel.snp.makeConstraints {
      $0.top.equalTo(remainingDistanceSectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
    }
    
    finishButton.snp.makeConstraints {
      $0.top.equalTo(remainingDistanceLabel.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  func configure(_ journey: ReadingJourney) {
    routeInfoView.configure(
      departure: journey.departureAirport,
      destination: journey.arrivalAirport
    )
    
    startDateLabel.text = journey.startedAt?.formattedDot ?? "-"
    currentPageLabel.text = "\(journey.currentPage ?? 0)p"
    distanceLabel.text = "\(Int(journey.distanceKm).formattedWithComma)km"
    
    if let remainingDistanceKm = journey.remainingDistanceKm {
      remainingDistanceLabel.text = "\(Int(remainingDistanceKm).formattedWithComma)km"
    } else {
      remainingDistanceLabel.text = "-"
    }
    
    currentPagePickerField.configure(maxPage: journey.book.itemPage)
    currentPagePickerField.setPage(journey.currentPage ?? 0)
  }
}

// MARK: - Private
private extension JourneyInfoView {
  func bind() {
    finishButton.addTarget(self, action: #selector(didTapFinish), for: .touchUpInside)
  }
  
  @objc func didTapCurrentPage() {
    currentPagePickerField.presentPicker()
  }
  
  @objc func didTapFinish() {
    onTapFinish?()
  }
}
