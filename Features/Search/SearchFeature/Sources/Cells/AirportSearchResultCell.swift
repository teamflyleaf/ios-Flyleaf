//
//  AirportSearchResultCell.swift
//  Search
//
//  Created by 여성일 on 3/15/26.
//

import Core
import DesignSystem
import Kingfisher
import SnapKit
import Then
import UIKit

final class AirportSearchResultCell: UICollectionViewCell {
  static let identifier = "AirportSearchResultCell"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - UI
  private let iconContainerView = UIView().then {
    $0.backgroundColor = .bg0
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .key0
  }
  
  private let iataLabel = UILabel().then {
    $0.font = .b2_sb
    $0.textColor = .n0
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }
  
  private let airportLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n20
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }
  
  private let textStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 2
    $0.alignment = .leading
    $0.distribution = .fill
  }
  
  // MARK: Public Method
  func configure(type: SearchType, item: AirportInfo) {
    iataLabel.text = item.displayName
    airportLabel.text = item.airportNameKo
    
    switch type {
    case .departureAirport:
      imageView.image = .takeOff.resized(24, 24)
    case .arrivalAirport:
      imageView.image = .landing.resized(24, 24)
    default:
      imageView.image = nil
    }
  }
}

// MARK: - Private
private extension AirportSearchResultCell {
  func configureUI() {
    [iconContainerView, textStackView].forEach {
      addSubview($0)
    }
    
    iconContainerView.addSubview(imageView)
    
    [iataLabel, airportLabel].forEach {
      textStackView.addArrangedSubview($0)
    }
    
    backgroundColor = .n60
    layer.cornerRadius = 12
  }
  
  func setupLayout() {
    iconContainerView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    
    imageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    textStackView.snp.makeConstraints {
      $0.leading.equalTo(iconContainerView.snp.trailing).offset(10)
      $0.centerY.equalToSuperview()
    }
  }
}
