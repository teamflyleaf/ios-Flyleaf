//
//  SettingInfoButton.swift
//  DesignSystem
//
//  Created by 여성일 on 4/21/26.
//

import Core
import UIKit
import SnapKit
import Then

/// 설정에서 사용할 정보 섹션 버튼입니다.
///
/// ```swift
/// let button = SettingInfoButton(title: "버그 신고")
/// ```
///
/// - Note:
///   - Auto Layout 사용 시 별도의 height 제약 없이 intrinsicContentSize를 통해 높이가 결정됩니다.
///   - width는 `noIntrinsicMetric`이므로 반드시 제약으로 설정해야 합니다.
///   - 높이 30로 고정입니다.
public final class SettingInfoButton: BaseView {
  let title: String
  
  public var onTap: (() -> Void)?
  
  // 기본 높이 설정: 60
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 30)
  }
  
  public init(
    title: String
  ) {
    self.title = title
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.font = .b2_sb
    $0.textColor = .n0
    $0.numberOfLines = 1
  }
  
  private let chevronRight = UIImageView().then {
    $0.image = .chevronRight.resized(24, 24)
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .n0
  }

  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .equalSpacing
    $0.spacing = 6
  }
  
  public override func configureUI() {
    addSubview(stackView)

    [
      titleLabel,
      chevronRight
    ].forEach {
      stackView.addArrangedSubview($0)
    }
    
    titleLabel.text = title
    
    setupTapGesture()
  }
  
  public override func setupLayout() {
    stackView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
}

// MARK: - Private
private extension SettingInfoButton {
  @objc func didTap() {
    onTap?()
  }
  
  func setupTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
}
