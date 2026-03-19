//
//  RegisterJourneyBookView.swift
//  Journey
//
//  Created by 여성일 on 3/19/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

final class RegisterJourneyBookView: BaseView {
  var onRegisterBookSearchTap: (() -> Void)?
  var onStartDateChanged: ((Date) -> Void)?
  var onReadingPageChanged: ((Int) -> Void)?
  var onTapNext: (() -> Void)?
  
  // MARK: - UI
  private let headerTitleLabel = UILabel().then {
    $0.font = .h3
    $0.text = "이미 시작한 여행이 있나요?"
    $0.textColor = .n0
  }
  
  private let headerSubTitleLabel = UILabel().then {
    $0.font = .b1_m
    $0.text = "읽고 있는 책을 찾아보세요"
    $0.textColor = .n20
  }
  
  private let bookSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "읽고 있는 책"
    $0.textColor = .n0
  }
  
  private let button = RegisterBookSearchButton()
  
  private let startSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "시작일"
    $0.textColor = .n0
    $0.isHidden = true
  }
  
  private let startDateField = NeutralDatePickerField(
    placeholder: "시작일을 선택해주세요"
  ).then {
    $0.isHidden = true
  }
  
  private let readingPageSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "읽은 페이지 수"
    $0.textColor = .n0
    $0.isHidden = true
  }
  
  private let readingPageField = NeutralPagePickerField().then {
    $0.isHidden = true
  }
  
  private let nextButton = CTAButton(title: "다음").then {
    $0.isHidden = true
    $0.isEnabled = false
  }
  
  override func configureUI() {
    [
      headerTitleLabel,
      headerSubTitleLabel,
      bookSectionTitleLabel,
      button,
      startSectionTitleLabel,
      startDateField,
      readingPageSectionTitleLabel,
      readingPageField,
      nextButton
    ].forEach {
      addSubview($0)
    }
    backgroundColor = .clear
    
    nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
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
    
    bookSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(headerSubTitleLabel.snp.bottom).offset(36)
      $0.leading.equalToSuperview()
    }
    
    button.snp.makeConstraints {
      $0.top.equalTo(bookSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    startSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(button.snp.bottom).offset(32)
      $0.leading.equalToSuperview()
    }
    
    startDateField.snp.makeConstraints {
      $0.top.equalTo(startSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(60)
    }
    
    readingPageSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(startDateField.snp.bottom).offset(32)
      $0.leading.equalToSuperview()
    }
        
    readingPageField.snp.makeConstraints {
      $0.top.equalTo(readingPageSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  func configure(_ item: BookInfo) {
    button.configure(
      state:.selected(
        title: item.title,
        author: item.author
      )
    )
    
    startSectionTitleLabel.isHidden = false
    startDateField.isHidden = false
    readingPageSectionTitleLabel.isHidden = false
    readingPageField.isHidden = false
    nextButton.isHidden = false
    
    readingPageField.configure(maxPage: item.itemPage)
  }
  
  func setNextButtonEnabled(_ isEnabled: Bool) {
    nextButton.isEnabled = isEnabled
  }
}

// MARK: - Private
private extension RegisterJourneyBookView {
  func bind() {
    button.configure(state: .placeholder(.journey))
    button.onTap = { [weak self] in
      self?.onRegisterBookSearchTap?()
    }
    
    readingPageField.onPageChanged = { [weak self] page in
      self?.onReadingPageChanged?(page)
    }
    
    startDateField.maximumDate = Date()
    startDateField.onDateChanged = { [weak self] date in
      self?.onStartDateChanged?(date)
    }
  }
  
  @objc func didTapNext() {
    onTapNext?()
  }
}
