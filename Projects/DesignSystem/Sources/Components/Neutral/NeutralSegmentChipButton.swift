//
//  NeutralSegmentChipButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/21/26.
//

import UIKit
import SnapKit
import Then

/// 아이콘과 텍스트를 함께 사용하는 세그먼트형 캡슐 버튼 컴포넌트입니다.
///
/// ```swift
/// let button = NeutralSegmentChipButton()
/// button.configure(
///   icon: .airplane,
///   title: "타임라인",
///   state: .selected
/// )
/// ```
///
/// - Note:
///   - 높이는 36으로 고정입니다.
///   - 선택 상태에서는 아이콘과 텍스트가 함께 표시됩니다.
///   - 비선택 상태에서는 아이콘만 표시됩니다.
///   - 상태 변경 시 배경색, 텍스트 색상, 아이콘 색상이 함께 변경됩니다.
///   - 상태 변경 시 width 변화가 자연스럽게 보이도록 애니메이션이 적용됩니다.
public final class NeutralSegmentChipButton: BaseView {
  public enum State {
    case normal
    case selected
  }
  
  public override var intrinsicContentSize: CGSize {
    let iconWidth: CGFloat = 16
    let horizontalPadding: CGFloat = 10 * 2
    let spacing: CGFloat = titleLabel.isHidden ? 0 : 4
    let titleWidth: CGFloat = titleLabel.isHidden ? 0 : titleLabel.intrinsicContentSize.width
    
    return CGSize(
      width: horizontalPadding + iconWidth + spacing + titleWidth,
      height: 36
    )
  }
  
  public var onTap: (() -> Void)?
  
  private var currentState: State = .normal
  
  // MARK: - UI
  private let contentButton = UIButton()
  
  private let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .n0
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .b2_sb
    $0.textColor = .n0
    $0.numberOfLines = 1
    $0.lineBreakMode = .byTruncatingTail
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.alignment = .center
  }
  
  public override func configureUI() {
    [
      stackView,
      contentButton
    ].forEach {
      addSubview($0)
    }
    
    [
      iconImageView,
      titleLabel
    ].forEach {
      stackView.addArrangedSubview($0)
    }

    layer.cornerRadius = 18
    clipsToBounds = true
    
    contentButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
  }
  
  public override func setupLayout() {
    stackView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    iconImageView.snp.makeConstraints {
      $0.width.height.equalTo(16)
    }
    
    contentButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  public func configure(
    icon: UIImage?,
    title: String,
    state: State
  ) {
    iconImageView.image = icon?.resized(16, 16)
    titleLabel.text = title
    updateState(state, animated: false)
  }
  
  public func updateState(
    _ state: State,
    animated: Bool = true
  ) {
    currentState = state

    switch state {
    case .normal:
      backgroundColor = .n30
      iconImageView.tintColor = .gray0
      titleLabel.textColor = .gray0
      titleLabel.isHidden = true

    case .selected:
      backgroundColor = .key0
      iconImageView.tintColor = .n0
      titleLabel.textColor = .n0
      titleLabel.isHidden = false
    }

    invalidateIntrinsicContentSize()
    setNeedsLayout()

    guard animated, window != nil else { return }

    UIView.animate(withDuration: 0.2) {
      self.superview?.layoutIfNeeded()
    }
  }
}

// MARK: - Private
private extension NeutralSegmentChipButton {
  @objc func didTap() {
    onTap?()
  }
}
