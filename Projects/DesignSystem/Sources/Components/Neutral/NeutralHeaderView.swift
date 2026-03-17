//
//  HeaderView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/5/26.
//

import UIKit
import Then
import SnapKit

/// 상단 네비게이션 영역을 구성하는 헤더 컴포넌트 입니다.
///
/// 좌측엔 백버튼, 중앙에는 타이틀이 배치되어 있습니다.
/// 화면 전환 시 공통적으로 사용할 수 있는 기본 헤더 컴포넌트입니다.
///
/// ```swift
/// let header = HeaderView(title: "탑승권 발급")
/// header.onTapBack = {
///   // 뒤로가기 처리
/// }
/// ```
///
/// - Note:
///   - Auto Layout 사용 시 별도의 height 제약 없이 intrinsicContentSize를 통해 높이가 결정됩니다.
///   - width는 `noIntrinsicMetric`이므로 반드시 제약으로 설정해야 합니다.
///   - 높이는 60 고정입니다.
///   - 배경색은 `.bg0`로 설정됩니다.
///   - 타이틀은 중앙 정렬됩니다.
public final class HeaderView: BaseView {
  // 기본 높이 설정: 60
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 60)
  }
  
  private let title: String
  
  /// BackButton Tapped 이벤트
  public var onTapBack: (() -> Void)?
  
  /// - Parameter title: 중앙에 표시할 타이틀 텍스트
  public init(title: String) {
    self.title = title
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
  
  private let titleLabel = UILabel().then {
    $0.textColor = .n0
    $0.font = .h4_sb
  }
  
  public override func configureUI() {
    [
      backButton,
      titleLabel
    ].forEach {
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
  /// BackButton Tapped 이벤트
  @objc func didTapBack() {
    onTapBack?()
  }
}
