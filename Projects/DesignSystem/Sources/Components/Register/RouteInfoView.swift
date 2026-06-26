//
//  RouteInfoView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/16/26.
//

import Core
import UIKit
import Then
import SnapKit

/// 출발지와 도착지의 경로 정보를 표시하는 뷰입니다.
///
/// /// ```swift
/// let routeView = RouteInfoView()
/// routeView.configure(
///   departure: departureAirport,
///   destination: destinationAirport
/// )
/// ```
///
/// - Note:
///   - Auto Layout 사용 시 별도의 height 제약 없이 intrinsicContentSize를 통해 높이가 결정됩니다.
///   - width는 `noIntrinsicMetric`이므로 반드시 제약으로 설정해야 합니다.
///   - 높이는 55 고정입니다.
public final class RouteInfoView: BaseView {
  // 기본 높이 설정: 55
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 55)
  }
  
  // MARK: - UI
  private let contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 12
    $0.alignment = .center
    $0.distribution = .fill
  }
  
  private let departureStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .leading
  }
  
  private let departureAirportLabel = UILabel().then {
    $0.textColor = .n0
    $0.font = .h1
    $0.numberOfLines = 1
  }
  
  private let departureCityLabel = UILabel().then {
    $0.textColor = .gray0
    $0.font = .b2_m
    $0.numberOfLines = 1
  }
  
  private let dotDividerView = DotDividerView()
  
  private let airplanImageView = UIImageView().then {
    $0.image = .airplane.resized(26, 26)
    $0.tintColor = .n0
  }
  
  private let distanceLabel = UILabel().then {
    $0.font = .b2_m
    $0.textColor = .n0
  }
  
  private let arrivalStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 4
    $0.alignment = .trailing
  }
  
  private let arrivalAirportLabel = UILabel().then {
    $0.textColor = .n0
    $0.font = .h1
    $0.numberOfLines = 1
  }
  
  private let arrivalCityLabel = UILabel().then {
    $0.textColor = .gray0 
    $0.font = .b2_m
    $0.numberOfLines = 1
  }
  
  public override func configureUI() {
    [
      contentStackView,
      airplanImageView,
      distanceLabel,
    ].forEach {
      addSubview($0)
    }
    
    [
      departureStackView,
      dotDividerView,
      arrivalStackView
    ].forEach {
      contentStackView.addArrangedSubview($0)
    }
    
    [
      departureAirportLabel,
      departureCityLabel
    ].forEach {
      departureStackView.addArrangedSubview($0)
    }
    
    [
      arrivalAirportLabel,
      arrivalCityLabel
    ].forEach {
      arrivalStackView.addArrangedSubview($0)
    }
    
    backgroundColor = .clear
  }
  
  public override func setupLayout() {
    contentStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    departureStackView.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    dotDividerView.snp.makeConstraints {
      $0.centerY.centerX.equalToSuperview()
      $0.width.equalTo(145)
    }
    
    airplanImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-0.5)
      $0.size.equalTo(26)
    }
    
    distanceLabel.snp.makeConstraints {
      $0.top.equalTo(airplanImageView.snp.bottom)
      $0.centerX.equalToSuperview()
    }
    
    arrivalStackView.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  // MARK: Public Method
  public func configure(
    departure: AirportInfo,
    destination: AirportInfo
  ) {
    departureAirportLabel.text = departure.iata
    departureCityLabel.text = departure.cityNameEn
    
    arrivalAirportLabel.text = destination.iata
    arrivalCityLabel.text = destination.cityNameEn
    
    distanceLabel.text = "\(AirportInfo.distanceKm(from: departure, to: destination).formattedWithComma)km"
  }
}
