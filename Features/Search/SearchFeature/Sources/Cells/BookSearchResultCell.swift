//
//  BookSearchResultCell.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

import Core
import DesignSystem
import Kingfisher
import SnapKit
import Then
import UIKit

final class BookSearchResultCell: UICollectionViewCell {
  static let identifier = "BookSearchResultCell"

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - UI
  private let coverImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 4
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.textColor = .n0
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }
  
  private let authorLabel = UILabel().then {
    $0.font = .b2_m
    $0.textColor = .n20
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }
  
  private let publisherLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n0
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }
  
  // MARK: Public Method
  func configure(item: BookSearchItem) {
    titleLabel.text = item.title
    authorLabel.text = item.author
    publisherLabel.text = item.publisher
    coverImageView.kf.setImage(with: URL(string: item.coverURL))
  }
}


// MARK: - Private
private extension BookSearchResultCell {
  func configureUI() {
    [coverImageView, titleLabel, authorLabel, publisherLabel].forEach {
      addSubview($0)
    }
    
    backgroundColor = .n60
    layer.cornerRadius = 12
  }
  
  func setupLayout() {
    coverImageView.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview().inset(12)
      $0.leading.equalToSuperview().offset(12)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(71)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.leading.equalTo(coverImageView.snp.trailing).offset(10)
      $0.trailing.equalToSuperview().inset(12)
    }
    
    authorLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(coverImageView.snp.trailing).offset(10)
      $0.trailing.equalToSuperview().inset(12)
    }
    
    publisherLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(12)
      $0.leading.equalTo(coverImageView.snp.trailing).offset(10)
      $0.trailing.equalToSuperview().inset(12)
    }
  }
}
