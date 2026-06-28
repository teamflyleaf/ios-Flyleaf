//
//  DetailHistoryView.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit
import ReadingJourneyInterface

final class DetailHistoryView: BaseView {
  var onStartDateChanged: ((Date) -> Void)?
  var onFinishDateChanged: ((Date) -> Void)?
  var onTapReview: (() -> Void)?
  
  // MARK: - UI
  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
  }
  
  private let contentView = UIView()
  private let routeBookInfoView = RouteBookInfoView()
  
  private let descriptionSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "책정보"
    $0.textColor = .n0
  }
  
  private let descriptionLabel = NeutralPaddingLabel().then {
    $0.font = .c2
    $0.textColor = .n0
    $0.backgroundColor = .n20
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
    $0.numberOfLines = 0
  }
  
  private let isbn13SectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "ISBN13"
    $0.textColor = .n0
  }
  
  private let isbn13Label = NeutralPaddingLabel().then {
    $0.font = .c2
    $0.textColor = .n0
    $0.backgroundColor = .n20
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
    $0.numberOfLines = 0
  }
  
  private let startSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "시작일"
    $0.textColor = .n0
  }
  
  private let startDateField = NeutralDatePickerField(placeholder: "-")
  
  private let finishSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "종료일"
    $0.textColor = .n0
  }
  
  private let finishDateField = NeutralDatePickerField(placeholder: "-")
  
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
  
  override func configureUI() {
    addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    [
      routeBookInfoView,
      descriptionSectionTitleLabel,
      descriptionLabel,
      isbn13SectionTitleLabel,
      isbn13Label,
      startSectionTitleLabel,
      startDateField,
      finishSectionTitleLabel,
      finishDateField,
      reviewSectionTitleLabel,
      reviewLabel
    ].forEach {
      contentView.addSubview($0)
    }
    
    backgroundColor = .clear
    bind()
  }
  
  override func setupLayout() {
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalTo(scrollView.frameLayoutGuide)
    }
    
    routeBookInfoView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
    }
    
    descriptionSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(routeBookInfoView.snp.bottom).offset(20)
      $0.leading.equalToSuperview()
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(descriptionSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    isbn13SectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
      $0.leading.equalToSuperview()
    }
    
    isbn13Label.snp.makeConstraints {
      $0.top.equalTo(isbn13SectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    startSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(isbn13Label.snp.bottom).offset(20)
      $0.leading.equalToSuperview()
    }
    
    startDateField.snp.makeConstraints {
      $0.top.equalTo(startSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    finishSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(startDateField.snp.bottom).offset(20)
      $0.leading.equalToSuperview()
    }
    
    finishDateField.snp.makeConstraints {
      $0.top.equalTo(finishSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    reviewSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(finishDateField.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
    }
    
    reviewLabel.snp.makeConstraints {
      $0.top.equalTo(reviewSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  func configure(_ journey: ReadingJourney) {
    routeBookInfoView.configure(
      bookItem: journey.book,
      departure: journey.departureAirport,
      destination: journey.arrivalAirport
    )
    
    descriptionLabel.text = journey.book.description.isEmpty ? "-" : journey.book.description
    isbn13Label.text = journey.book.isbn13
    if let startedAt = journey.startedAt {
      startDateField.setDate(startedAt)
    } else {
      startDateField.clear()
    }

    if let finishedAt = journey.finishedAt {
      finishDateField.setDate(finishedAt)
    } else {
      finishDateField.clear()
    }
    
    startDateField.maximumDate = journey.finishedAt
    finishDateField.minimumDate = journey.startedAt
    finishDateField.maximumDate = Date()
    
    reviewLabel.text = journey.review ?? "-"
  }
}

private extension DetailHistoryView {
  @objc func didTapReview() {
    onTapReview?()
  }
  
  func bind() {
    startDateField.onDateChanged = { [weak self] date in
      self?.finishDateField.minimumDate = date
      self?.onStartDateChanged?(date)
    }
    
    finishDateField.onDateChanged = { [weak self] date in
      self?.startDateField.maximumDate = date
      self?.onFinishDateChanged?(date)
    }
    
    reviewLabel.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapReview))
    reviewLabel.addGestureRecognizer(tapGesture)
  }
}
