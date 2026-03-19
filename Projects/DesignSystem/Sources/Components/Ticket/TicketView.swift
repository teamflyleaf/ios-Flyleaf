//
//  TicketView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/16/26.
//

import Core
import UIKit
import SnapKit
import Then

/// 탑승권(티켓) 뷰 입니다.
///
/// 책 정보, 공항 정보, 페이지 수, 이동 거리, 바코드 영역을 포함한 탑승권 UI입니다.
///
/// ```swift
/// let ticketView = TicketView()
/// ticketView.configure(
///   bookItem: book,
///   departure: departureAirport,
///   destination: destinationAirport
/// )
/// ```
public final class TicketView: BaseView {
  // MARK: - UI
  private let shapeView = TicketShapeView()
  
  private let logoView = UILabel().then {
    $0.text = "Flyleaf"
    $0.font = .c3
    $0.textColor = .key0
    $0.textAlignment = .center
    $0.backgroundColor = .n50
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
  }
  
  private let routeBookInfoView = RouteBookInfoView()
  
  private let startTitleLabel = UILabel().then {
    $0.font = .c3
    $0.text = "출발"
    $0.textColor = .n0
    $0.textAlignment = .left
  }
  
  private let startPageLabel = UILabel().then {
    $0.font = .h4_sb
    $0.text = "0p"
    $0.textColor = .n0
  }
  
  private let arriveTitleLabel = UILabel().then {
    $0.font = .c3
    $0.text = "도착"
    $0.textColor = .n0
    $0.textAlignment = .center
  }
  
  private let arrivePageLabel = UILabel().then {
    $0.font = .h4_sb
    $0.textColor = .n0
    $0.textAlignment = .center
  }
  
  private let distanceTitleLabel = UILabel().then {
    $0.font = .c3
    $0.text = "거리"
    $0.textColor = .n0
    $0.textAlignment = .right
  }
  
  private let distanceLabel = UILabel().then {
    $0.font = .h4_sb
    $0.textColor = .n0
    $0.textAlignment = .right
  }
  
  private let barcodeView = BarcodeView()

  public override func configureUI() {
    addSubview(shapeView)

    [
      logoView,
      routeBookInfoView,
      startTitleLabel,
      startPageLabel,
      arriveTitleLabel,
      arrivePageLabel,
      distanceTitleLabel,
      distanceLabel,
      barcodeView
    ].forEach {
      shapeView.addSubview($0)
    }
  }

  public override func setupLayout() {
    shapeView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    logoView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.height.equalTo(24)
      $0.width.equalTo(55)
    }
    
    routeBookInfoView.snp.makeConstraints {
      $0.top.equalTo(logoView.snp.bottom).offset(6)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    startTitleLabel.snp.makeConstraints {
      $0.top.equalTo(routeBookInfoView.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    startPageLabel.snp.makeConstraints {
      $0.top.equalTo(startTitleLabel.snp.bottom).offset(4)
      $0.leading.equalToSuperview().offset(20)
    }
    
    arriveTitleLabel.snp.makeConstraints {
      $0.top.equalTo(routeBookInfoView.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
    
    arrivePageLabel.snp.makeConstraints {
      $0.top.equalTo(arriveTitleLabel.snp.bottom).offset(4)
      $0.centerX.equalToSuperview()
    }
        
    distanceTitleLabel.snp.makeConstraints {
      $0.top.equalTo(routeBookInfoView.snp.bottom).offset(20)
      $0.trailing.equalToSuperview().inset(20)
    }
    
    distanceLabel.snp.makeConstraints {
      $0.top.equalTo(distanceTitleLabel.snp.bottom).offset(4)
      $0.trailing.equalToSuperview().inset(20)
    }

    barcodeView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(24)
      $0.height.equalTo(64)
    }
  }

  // MARK: - Public Method
  public func configure(
    bookItem: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    startPage: Int = 0
  ) {
    routeBookInfoView.configure(
      bookItem: bookItem,
      departure: departure,
      destination: destination
    )
    startPageLabel.text = "\(startPage)p"
    arrivePageLabel.text = "\(bookItem.itemPage)p"
    distanceLabel.text = "\(AirportInfo.distanceKm(from: departure, to: destination).formattedWithComma)km"
  }
}
