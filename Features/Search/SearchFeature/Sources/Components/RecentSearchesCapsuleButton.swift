//
//  RecentSearchesCapsuleButton.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

import DesignSystem
import SnapKit
import Then
import UIKit

/// 최근 검색어를 표시하는 캡슐 형태의 UI 컴포넌트입니다.
/// 텍스트와 삭제 버튼으로 구성되며, 캡슐 영역 탭과 삭제 버튼 탭 이벤트를 각각 처리할 수 있습니다.
final class RecentSearchesCapsuleButton: BaseView {
  override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 40)
  }
  
  var onTap: (() -> Void)?
  var onTapDelete: (() -> Void)?

  // MARK: - UI
  private let contentButton = UIButton()

  private let titleLabel = UILabel().then {
    $0.font = .b1_m
    $0.textColor = .n0
    $0.numberOfLines = 1
    $0.textAlignment = .center
  }

  private let deleteButton = UIButton().then {
    $0.setImage(.xmark, for: .normal)
    $0.tintColor = .n20
  }

  override func configureUI() {
    [contentButton, titleLabel, deleteButton].forEach {
      addSubview($0)
    }
    
    backgroundColor = .clear
    layer.cornerRadius = 20
    layer.borderWidth = 1
    layer.borderColor = UIColor.n0.cgColor
    
    contentButton.addTarget(self, action: #selector(didTapCapsule), for: .touchUpInside)
    deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
  }
  
  override func setupLayout() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(18)
      $0.centerY.equalToSuperview()
    }

    deleteButton.snp.makeConstraints {
      $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
      $0.trailing.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    contentButton.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview()
      $0.trailing.equalTo(deleteButton.snp.leading)
    }
  }
  
  // MARK: Public Method
  func configure(text: String) {
    titleLabel.text = truncatedText(text)
  }
}

// MARK: - Private
private extension RecentSearchesCapsuleButton {
  @objc func didTapCapsule() {
    onTap?()
  }

  @objc func didTapDelete() {
    onTapDelete?()
  }
  
  // 텍스트가 8자를 초과하면 앞 8자만 표시하고 `...`으로 축약하는 메소드
  func truncatedText(_ text: String) -> String {
    if text.count <= 8 {
      return text
    }
    let index = text.index(text.startIndex, offsetBy: 8)
    return "\(text[..<index])..."
  }
}
