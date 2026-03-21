//
//  WishTicket.swift
//  DesignSystem
//
//  Created by 여성일 on 3/20/26.
//

import Core
import UIKit
import SnapKit
import Then

/// 예약 티켓 뷰 입니다.
///
/// 책 정보, 공항 정보, 페이지 수, 예약 날짜 정보를 담고 있는 티켓 UI입니다.
///
/// ```swift
/// let wishTicketView = WishTicketView()
/// wishTicketView.configure(
///   bookItem: book,
///   departure: departureAirport,
///   destination: destinationAirport,
///   registerDate: Date(),
///   reason: reason
/// )
/// ```
public final class WishTicketView: BaseView {
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 260)
  }
  
  // MARK: - UI
  private let shapeView = TicketShapeView()

  private let registerDateLabel = NeutralCapsuleView()
  private let pageLabel = NeutralCapsuleView()
  private let routeInfoView = RouteInfoView()

  private let distanceLabel = UILabel().then {
    $0.font = .b2_m
    $0.textColor = .n0
  }
  
  private let bookTitleSectionTitleLabel = UILabel().then {
    $0.font = .c3
    $0.text = "책"
    $0.textColor = .n0
    $0.textAlignment = .left
  }

  private let bookTitleLabel = UILabel().then {
    $0.font = .h4_sb
    $0.textColor = .n0
    $0.numberOfLines = 1
  }

  private let authorSectionTitleLabel = UILabel().then {
    $0.font = .c3
    $0.text = "작가"
    $0.textColor = .n0
    $0.textAlignment = .right
  }

  private let authorLabel = UILabel().then {
    $0.font = .h4_sb
    $0.textColor = .n0
    $0.textAlignment = .right
    $0.numberOfLines = 1
  }

  private let reasonLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n20
  }

  private let bookInfoStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.spacing = 4
  }

  private let authorInfoStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.spacing = 4
  }

  private let titleRowStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .top
    $0.distribution = .fillEqually
    $0.spacing = 20
  }

  public override func configureUI() {
    addSubview(shapeView)

    [
      registerDateLabel,
      pageLabel,
      routeInfoView,
      distanceLabel,
      titleRowStackView,
      reasonLabel
    ].forEach {
      shapeView.addSubview($0)
    }

    [
      bookTitleSectionTitleLabel,
      bookTitleLabel
    ].forEach {
      bookInfoStackView.addArrangedSubview($0)
    }

    [
      authorSectionTitleLabel,
      authorLabel
    ].forEach {
      authorInfoStackView.addArrangedSubview($0)
    }

    [
      bookInfoStackView,
      authorInfoStackView
    ].forEach {
      titleRowStackView.addArrangedSubview($0)
    }
  }

  public override func setupLayout() {
    shapeView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    registerDateLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.equalToSuperview().offset(20)
    }

    pageLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().inset(20)
    }

    routeInfoView.snp.makeConstraints {
      $0.top.equalTo(registerDateLabel.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }

    distanceLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(routeInfoView.snp.centerY).offset(10)
    }
    
    titleRowStackView.snp.makeConstraints {
      $0.top.equalTo(routeInfoView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }

    reasonLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }

  // MARK: - Public Method
  public func configure(
    bookItem: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    registerDate: Date,
    reason: String
  ) {
    routeInfoView.configure(
      departure: departure,
      destination: destination
    )

    bookTitleLabel.text = bookItem.title
    authorLabel.text = bookItem.author
    registerDateLabel.configure(image: .calendar, text: registerDate.formattedDot)
    pageLabel.configure(image: .openBook, text: "\(bookItem.itemPage)p")
    reasonLabel.text = reason
  }
}
