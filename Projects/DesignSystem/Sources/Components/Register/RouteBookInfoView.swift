//
//  CheckBookView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/16/26.
//

import Core
import Kingfisher
import UIKit
import Then
import SnapKit

/// 경로 정보와 책 정보를 함께 표시하는 뷰 입니다.
///
/// 상단에는 출발지/도착지 경로 정보가 표시됩니다.
/// 하단에는 책 정보가 표시됩니다.
/// ```swift
/// let view = RouteBookInfoView()
/// view.configure(
///   bookItem: book,
///   departure: departureAirport,
///   destination: destinationAirport
/// )
/// ```
/// - Note:
///   - 경로 정보는 내부 `RouteInfoView`를 통해 표시됩니다.
///   - 책 표지는 `Kingfisher`를 사용하여 비동기 로드됩니다.
///   - 전체 높이는 내부 콘텐츠에 따라 자동으로 결정됩니다.
public final class RouteBookInfoView: BaseView {
  // MARK: - UI
  private let routeInfoView = RouteInfoView()
  
  private let bookCoverImageView = UIImageView().then {
    $0.image = .book
    $0.backgroundColor = .key0
    $0.layer.cornerRadius = 4
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let bookTitleLabel = UILabel().then {
    $0.font = .h4_sb
    $0.textColor = .n0
    $0.numberOfLines = 1
    $0.textAlignment = .center
  }
  
  private let autherLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .gray0
    $0.numberOfLines = 1
    $0.textAlignment = .center
  }
  
  public override func configureUI() {
    [
      routeInfoView,
      bookCoverImageView,
      bookTitleLabel,
      autherLabel
    ].forEach {
      addSubview($0)
    }
    
    backgroundColor = .clear
  }
  
  public override func setupLayout() {
    routeInfoView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
    
    bookCoverImageView.snp.makeConstraints {
      $0.top.equalTo(routeInfoView.snp.bottom).offset(20)
      $0.width.equalTo(120)
      $0.height.equalTo(180)
      $0.centerX.equalToSuperview()
    }
    
    bookTitleLabel.snp.makeConstraints {
      $0.top.equalTo(bookCoverImageView.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
      $0.horizontalEdges.equalToSuperview().inset(50)
    }
    
    autherLabel.snp.makeConstraints {
      $0.top.equalTo(bookTitleLabel.snp.bottom)
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.horizontalEdges.equalToSuperview().inset(50)
    }
  }
  
  // MARK: - Public
  public func configure(bookItem: BookInfo, departure: AirportInfo, destination: AirportInfo) {
    bookCoverImageView.kf.setImage(with: URL(string: bookItem.cover))
    bookTitleLabel.text = bookItem.title
    autherLabel.text = bookItem.author
    
    routeInfoView.configure(departure: departure, destination: destination)
  }
}
