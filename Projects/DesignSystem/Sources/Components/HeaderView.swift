//
//  HeaderView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/5/26.
//

import UIKit
import Then
import SnapKit

public final class HeaderView: BaseView {
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 60)
  }
  
  private let title: String
  
  /// BackButton Tapped 이벤트
  public var onTapBack: (() -> Void)?
  
  public init(title: String) {
    self.title = title
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private let backButton = UIButton().then {
    $0.setImage(.chevronLeft, for: .normal)
    $0.tintColor = .n0
  }
  
  private let titleLabel = UILabel().then {
    $0.textColor = .n0
    $0.font = .h4_sb
  }
  
  public override func configureUI() {
    [backButton, titleLabel].forEach {
      addSubview($0)
    }
    backgroundColor = .bg0
    
    titleLabel.text = title
    
    backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
  }
  
  public override func setupLayout() {
    backButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
}

// MARK: - Actions
private extension HeaderView {
  @objc func didTapBack() {
    onTapBack?()
  }
}
