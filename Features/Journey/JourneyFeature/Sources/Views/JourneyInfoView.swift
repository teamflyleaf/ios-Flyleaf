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
  
  override func configureUI() {
    [
      routeInfoView,
      startDateSectionTitleLabel,
      startDateLabel,
      currentPageSectionTitleLabel,
      currentPageLabel,
      distanceSectionTitleLabel,
      distanceLabel,
      remainingDistanceSectionTitleLabel,
      remainingDistanceLabel
    ].forEach {
      addSubview($0)
    }
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
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Public
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
  }
}
