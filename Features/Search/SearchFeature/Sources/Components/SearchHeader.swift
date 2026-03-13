//
//  SearchHeader.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

import DesignSystem
import UIKit
import Then
import SnapKit

public final class SearchHeader: BaseView {
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 60)
  }
  
  public var onTapBack: (() -> Void)?
  
  public init() {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - UI
  private let backButton = UIButton().then {
    $0.setImage(.chevronLeft, for: .normal)
    $0.tintColor = .n0
  }
  
  public let searchTextField = SearchTextField().then {
    $0.font = .b1_m
    $0.textColor = .n0
    $0.backgroundColor = .n60
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
  }
  
  public override func configureUI() {
    [backButton, searchTextField].forEach {
      addSubview($0)
    }
    backgroundColor = .bg0

    backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
  }
  
  public override func setupLayout() {
    backButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    searchTextField.snp.makeConstraints {
      $0.height.equalTo(40)
      $0.leading.equalTo(backButton.snp.trailing).offset(20)
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  public func setPlaceholder(_ text: String) {
    searchTextField.setPlaceholder(text, color: .n20)
  }
}

// MARK: - Actions
private extension SearchHeader {
  @objc func didTapBack() {
    onTapBack?()
  }
}

