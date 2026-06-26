//
//  SelectRouteview.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

final class SelectRouteView: BaseView {
  var onTapSelectDepartureButton: (() -> Void)?
  var onTapSelectDestinationButton: (() -> Void)?
  var onTapPrev: (() -> Void)?
  var onTapNext: (() -> Void)?
  private var isDepartureSelected = false
  private var isDestinationSelected = false
  
  // MARK: - UI
  private let headerTitleLabel = UILabel().then {
    $0.font = .h3
    $0.text = "어디에서 출발했나요?"
    $0.textColor = .n0
  }
  
  private let headerSubTitleLabel = UILabel().then {
    $0.font = .b1_m
    $0.text = "출발지와 목적지를 선택해주세요"
    $0.textColor = .gray0
  }
  
  private let departureSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "출발지"
    $0.textColor = .n0
  }
  
  private let selectDepartureButton = SelectRouteButton()
  
  private let destinationSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "도착지"
    $0.textColor = .n0
  }
  
  private let selectDestinationButton = SelectRouteButton()
  
  private let actionButtonView = StepActionButtonView()
  
  override func configureUI() {
    [
      headerTitleLabel,
      headerSubTitleLabel,
      departureSectionTitleLabel,
      selectDepartureButton,
      destinationSectionTitleLabel,
      selectDestinationButton,
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
    
    departureSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(headerSubTitleLabel.snp.bottom).offset(36)
      $0.leading.equalToSuperview()
    }
    
    selectDepartureButton.snp.makeConstraints {
      $0.top.equalTo(departureSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    destinationSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(selectDepartureButton.snp.bottom).offset(32)
      $0.leading.equalToSuperview()
    }
    
    selectDestinationButton.snp.makeConstraints {
      $0.top.equalTo(destinationSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    actionButtonView.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  func configureDeparture(_ item: AirportInfo) {
    isDepartureSelected = true
    
    selectDepartureButton.configure(
      state: .selected(
        type: .departureAirport,
        iata: item.displayName,
        airport: item.airportNameKo
      )
    )
    
    updateButtonLayout()
  }

  func configureDestination(_ item: AirportInfo) {
    isDestinationSelected = true
    
    selectDestinationButton.configure(
      state: .selected(
        type: .arrivalAirport,
        iata: item.displayName,
        airport: item.airportNameKo
      )
    )
    
    updateButtonLayout()
  }
}

// MARK: - Private
private extension SelectRouteView {
  func bind() {
    selectDepartureButton.configure(state: .placeholder(.departureAirport))
    selectDepartureButton.onTap = { [weak self] in
      self?.onTapSelectDepartureButton?()
    }
    
    selectDestinationButton.configure(state: .placeholder(.arrivalAirport))
    selectDestinationButton.onTap = { [weak self] in
      self?.onTapSelectDestinationButton?()
    }
    
    actionButtonView.onTapPrev = { [weak self] in
      self?.onTapPrev?()
    }
    
    actionButtonView.onTapNext = { [weak self] in
      self?.onTapNext?()
    }
    
    updateButtonLayout()
  }
  
  func updateButtonLayout() {
    let isRouteReady = isDepartureSelected && isDestinationSelected
    actionButtonView.configure(isNextEnabled: isRouteReady)
  }
}
