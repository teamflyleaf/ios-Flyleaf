//
//  RecentSearchsView.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

import DesignSystem
import SnapKit
import Then
import UIKit

final class RecentSearchesView: BaseView {
  var onTapDeleteAll: (() -> Void)?
  var onTapDeleteRecentSearch: ((String) -> Void)?
  var onTapRecentSearch: ((String) -> Void)?
  
  private var items: [String] = []
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.text = "최근 검색어"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let deleteButton = UIButton().then {
    $0.setTitle("전체삭제", for: .normal)
    $0.setTitleColor(.n20, for: .normal)
    $0.titleLabel?.font = .b2_m
  }
  
  private let scrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
    $0.alwaysBounceHorizontal = true
    $0.backgroundColor = .clear
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 6
    $0.alignment = .fill
    $0.distribution = .fill
  }
  
  override func configureUI() {
    [titleLabel, deleteButton, scrollView].forEach {
      addSubview($0)
    }
    scrollView.addSubview(stackView)
    backgroundColor = .clear

    deleteButton.addTarget(self, action: #selector(didTapDeleteAll), for: .touchUpInside)
  }
  
  override func setupLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(18)
    }

    deleteButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview().inset(18)
    }
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview()
      $0.height.equalTo(40)
    }
    
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalToSuperview()
    }
  }
  
  // MARK: Public Method
  func configure(items: [String]) {
    self.items = items
    reloadCapsules()
  }
}

// MARK: - Private
private extension RecentSearchesView {
  func reloadCapsules() {
    stackView.arrangedSubviews.forEach { view in
      stackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
    
    items.forEach { item in
      let capsuleButton = RecentSearchesCapsuleButton()
      capsuleButton.configure(text: item)
      
      capsuleButton.onTap = { [weak self] in
        self?.onTapRecentSearch?(item)
      }
      
      capsuleButton.onTapDelete = { [weak self] in
        self?.onTapDeleteRecentSearch?(item)
      }
      
      stackView.addArrangedSubview(capsuleButton)
    }
  }
  
  @objc func didTapDeleteAll() {
    onTapDeleteAll?()
  }
}

