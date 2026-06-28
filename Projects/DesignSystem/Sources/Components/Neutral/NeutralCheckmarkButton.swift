//
//  NeutralCheckmarkButton.swift
//  DesignSystem
//
//  Created by 여성일 on 6/28/26.
//

import UIKit
import Then
import SnapKit

public final class NeutralCheckmarkButton: UIControl {
  // 기본 높이 설정: 52
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 52)
  }
  
  public override var isSelected: Bool {
    didSet { updateAppearance() }
  }
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let checkmarkImageView = UIImageView().then {
    $0.image = .checkmark
    $0.tintColor = .n0
  }
  
  /// - Parameter title: 버튼에 표시할 텍스트
  public init(title: String) {
    super.init(frame: .zero)
    configure(title: title)
    setupLayout()
    updateAppearance()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private
private extension NeutralCheckmarkButton {
  func configure(title: String) {
    [
      titleLabel,
      checkmarkImageView
    ].forEach {
      addSubview($0)
    }
    
    titleLabel.text = title
    backgroundColor = .clear
    
    clipsToBounds = true
  }
  
  func setupLayout() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
    
    checkmarkImageView.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  func updateAppearance() {
    checkmarkImageView.isHidden = !isSelected
  }
}
