//
//  MemoTableViewCell.swift
//  Journey
//
//  Created by 여성일 on 3/22/26.
//

import Core
import SnapKit
import Then
import UIKit
import ReadingJourneyInterface

final class MemoTableViewCell: UITableViewCell {
  static let identifier = "MemoTableViewCell"
  
  // MARK: - UI
  private let contentLabel = UILabel().then {
    $0.font = .b2_sb
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let infoLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n20
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    contentLabel.text = nil
    infoLabel.text = nil
  }
}

// MARK: - Public
extension MemoTableViewCell {
  func configure(_ memo: JourneyMemo) {
    contentLabel.text = memo.content
    infoLabel.text = "\(memo.page)p / \(memo.createdAt.formattedDot)"
  }
}

// MARK: - Private
private extension MemoTableViewCell {
  func configureUI() {
    selectionStyle = .none
    backgroundColor = .n60
    
    [
      contentLabel,
      infoLabel
    ].forEach {
      contentView.addSubview($0)
    }
    
    layer.cornerRadius = 16
    clipsToBounds = true
  }
  
  func setupLayout() {
    contentLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.horizontalEdges.equalToSuperview().inset(12)
    }
    
    infoLabel.snp.makeConstraints {
      $0.top.equalTo(contentLabel.snp.bottom).offset(8)
      $0.trailing.equalToSuperview().inset(12)
      $0.bottom.equalToSuperview().inset(12)
    }
  }
}
