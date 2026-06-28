//
//  BookInfoView.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

final class BookInfoView: BaseView {
  // MARK: - UI
  private let bookCoverImageView = UIImageView().then {
    $0.layer.cornerRadius = 5
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
  
  private let descriptionSectionTitleLabel = UILabel().then {
    $0.text = "책소개"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let descriptionLabl = UILabel().then {
    $0.font = .c3
    $0.textColor = .gray0
    $0.textAlignment = .left
    $0.numberOfLines = 0
  }
  
  private let publisherSectionTitleLabel = UILabel().then {
    $0.text = "출판사"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let publisherLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .gray0
    $0.textAlignment = .left
  }
    
  private let itemPageSectionTitleLabel = UILabel().then {
    $0.text = "페이지"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let itemPageLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .gray0
    $0.textAlignment = .left
  }
      
  private let isbn13SectionTitleLabel = UILabel().then {
    $0.text = "ISBN13"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let isbn13Label = UILabel().then {
    $0.font = .c3
    $0.textColor = .gray0
    $0.textAlignment = .left
  }
  
  override func configureUI() {
    [
      bookCoverImageView,
      bookTitleLabel,
      autherLabel,
      descriptionSectionTitleLabel,
      descriptionLabl,
      publisherSectionTitleLabel,
      publisherLabel,
      itemPageSectionTitleLabel,
      itemPageLabel,
      isbn13SectionTitleLabel,
      isbn13Label
    ].forEach {
      addSubview($0)
    }
  }
  
  override func setupLayout() {
    bookCoverImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.width.equalTo(100)
      $0.height.equalTo(160)
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
      $0.horizontalEdges.equalToSuperview().inset(50)
    }
    
    descriptionSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(autherLabel.snp.bottom).offset(40)
      $0.leading.equalToSuperview()
    }
    
    descriptionLabl.snp.makeConstraints {
      $0.top.equalTo(descriptionSectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
    }
    
    publisherSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(descriptionLabl.snp.bottom).offset(32)
      $0.leading.equalToSuperview()
    }
    
    publisherLabel.snp.makeConstraints {
      $0.top.equalTo(publisherSectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
    }
    
    itemPageSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(publisherLabel.snp.bottom).offset(32)
      $0.leading.equalToSuperview()
    }
    
    itemPageLabel.snp.makeConstraints {
      $0.top.equalTo(itemPageSectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
    }
    
    isbn13SectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(itemPageLabel.snp.bottom).offset(32)
      $0.leading.equalToSuperview()
    }
    
    isbn13Label.snp.makeConstraints {
      $0.top.equalTo(isbn13SectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: - Public
  func configure(
    _ item: BookInfo
  ) {
    bookCoverImageView.kf.setImage(with: URL(string: item.cover))
    bookTitleLabel.text = item.title
    autherLabel.text = item.author
    descriptionLabl.text = item.description
    publisherLabel.text = item.publisher
    itemPageLabel.text = "\(item.itemPage.formattedWithComma)p"
    isbn13Label.text = item.isbn13
  }
}
