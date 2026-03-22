//
//  JourneyProgressButtonCell.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import Core
import DesignSystem
import SnapKit
import UIKit

final class JourneyProgressButtonCell: UICollectionViewCell {
  static let identifier = "JourneyProgressButtonCell"
  
  // MARK: - UI
  private let progressButton = JourneyProgressButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  // MARK: - Public Method
  func configure(
    airport: AirportInfo,
    book: BookInfo,
    currentPage: Int
  ) {
    progressButton.configure(
      airport: airport,
      book: book,
      currentPage: currentPage
    )
  }
  
  func setSelected(_ isSelected: Bool) {
    progressButton.isSelectedState = isSelected
  }
}

// MARK: - Private
private extension JourneyProgressButtonCell {
  func configureUI() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    contentView.addSubview(progressButton)
  }
  
  func setupLayout() {
    progressButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
