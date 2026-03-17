//
//  StepActionButtonView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/16/26.
//

import SnapKit
import Then
import UIKit

/// 이전/다음 액션 버튼을 함께 제공하는 스텝 전용 버튼 뷰입니다.
///
/// 두 개의 `CTAButton`을 수평으로 배치하며,
/// 상태에 따라 다음 버튼을 숨기거나 동일한 비율로 분할(2분할)할 수 있습니다.
///
/// ```swift
/// let actionView = StepActionButtonView()
/// actionView.configure(isNextEnabled: true)
///
/// actionView.onTapPrev = { ... }
/// actionView.onTapNext = { ... }
/// ```
///
/// - Note:
///   - 다음 버튼이 숨겨진 경우, 이전 버튼이 전체 너비를 차지합니다.
///   - 두 버튼이 모두 보일 경우 `.fillEqually`로 동일한 비율로 배치됩니다.
public final class StepActionButtonView: BaseView {
  /// 이전 탭 버튼 이벤트
  public var onTapPrev: (() -> Void)?
  
  /// 다음 탭 버튼 이벤트
  public var onTapNext: (() -> Void)?
  
  // MARK: - UI
  private let prevButton = CTAButton(title: "이전").then {
    $0.backgroundColor = .n30
  }
  
  private let nextButton = CTAButton(title: "다음")
  
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.distribution = .fill
    $0.alignment = .fill
  }
  
  public override func configureUI() {
    addSubview(stackView)
    
    [
      prevButton,
      nextButton
    ].forEach {
      stackView.addArrangedSubview($0)
    }
    
    backgroundColor = .clear
    
    prevButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
    nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
  }
  
  public override func setupLayout() {
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  public func configure(isNextEnabled: Bool) {
    nextButton.isHidden = !isNextEnabled
    stackView.distribution = isNextEnabled ? .fillEqually : .fill
  }
  
  /// 이전 버튼의 타이틀을 설정합니다.
  /// - Parameter title: prevButton 타이틀
  public func setPrevButtonTitle(_ title: String) {
    prevButton.setTitle(title, for: .normal)
  }
  
  /// 다음 버튼의 타이틀을 설정합니다.
  /// - Parameter title: nextButton 타이틀
  public func setNextButtonTitle(_ title: String) {
    nextButton.setTitle(title, for: .normal)
  }
  
  /// 다음 버튼의 표시 여부를 직접 제어합니다.
  ///
  /// - Parameter isHidden: 숨김 여부
  ///
  /// - Note:
  ///   - 숨김 시 이전 버튼이 전체 너비를 차지합니다.
  public func setNextButtonHidden(_ isHidden: Bool) {
    nextButton.isHidden = isHidden
    stackView.distribution = isHidden ? .fill : .fillEqually
  }
}

// MARK: - Private
private extension StepActionButtonView {
  @objc func didTapPrev() {
    onTapPrev?()
  }
  
  @objc func didTapNext() {
    onTapNext?()
  }
}
