//
//  RegisterBookSearchButton.swift
//  Wishlist
//
//  Created by 여성일 on 3/13/26.
//

import SnapKit
import Then
import UIKit

/// 책 등록 목적에 따라 표시 문구를 정의하는 타입
public enum RegisterBookType {
  case wishlist
  case history
  case journey
  
  public var title: String {
    switch self {
    case .wishlist:
      return "버튼을 눌러 읽고 싶은 책을 등록하세요"
    case .history:
      return "버튼을 눌러 다 읽은 책을 등록하세요"
    case .journey:
      return "버튼을 눌러 읽고 있는 책을 등록하세요"
    }
  }
}

/// `RegisterBookSearchButton`의 표시 상태
public enum RegisterBookSearchButtonState {
  case placeholder(RegisterBookType)
  case selected(title: String, author: String)
}

/// 책 검색 및 선택을 위한 버튼형 UI 컴포넌트 입니다.
///
/// 초기에는 안내 문구와 검색 아이콘을 표시하고,
/// 책이 선택되면 책 제목 / 저자 / 책 아이콘으로 상태가 변경됩니다.
///
/// ```swift
/// let button = RegisterBookSearchButton()
/// button.configure(state: .placeholder(.wishlist))
///
/// button.onTap = {
///   print("책 검색 화면으로 이동")
/// }
/// ```
///
/// - Note:
///   - Auto Layout 사용 시 별도의 height 제약 없이 intrinsicContentSize를 통해 높이가 결정됩니다.
///   - width는 `noIntrinsicMetric`이므로 반드시 제약으로 설정해야 합니다.
///   - 높이는 60 고정입니다.
///   - 전체 탭 영역은 내부 `contentButton`이 담당합니다.
public final class RegisterBookSearchButton: BaseView {
  // 기본 높이 설정: 60
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 60)
  }
  
  /// 버튼 탭 이벤트
  public var onTap: (() -> Void)?
  
  // MARK: - UI
  // 전체 탭 영역 버튼
  private let contentButton = UIButton()
  
  private let iconContainerView = UIView().then {
    $0.backgroundColor = .bg0
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .key0
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .c2
    $0.textColor = .n20
  }
  
  private let bookTitleLabel = UILabel().then {
    $0.font = .b2_sb
    $0.textColor = .n0
    $0.numberOfLines = 1
  }
  
  private let authorLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .n20
    $0.numberOfLines = 1
  }
  
  private let textStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 2
    $0.alignment = .leading
    $0.distribution = .fill
  }
  
  private let chevron = UIImageView().then {
    $0.image = .right
    $0.tintColor = .n20
  }
  
  public override func configureUI() {
    [
      iconContainerView,
      titleLabel,
      textStackView,
      chevron,
      contentButton
    ].forEach {
      addSubview($0)
    }
    
    iconContainerView.addSubview(imageView)
    
    [
      bookTitleLabel,
      authorLabel
    ].forEach {
      textStackView.addArrangedSubview($0)
    }
    
    backgroundColor = .n60
    layer.cornerRadius = 16
    
    contentButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
  }
  
  public override func setupLayout() {
    iconContainerView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.centerY.equalToSuperview()
      $0.width.height.equalTo(40)
    }
    
    imageView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(iconContainerView.snp.trailing).offset(10)
      $0.centerY.equalToSuperview()
    }
    
    textStackView.snp.makeConstraints {
      $0.leading.equalTo(iconContainerView.snp.trailing).offset(10)
      $0.trailing.equalTo(chevron.snp.leading).inset(-10)
      $0.centerY.equalToSuperview()
    }
    
    chevron.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(10)
      $0.width.height.equalTo(20)
      $0.centerY.equalToSuperview()
    }
    
    contentButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  public func configure(state: RegisterBookSearchButtonState) {
    switch state {
    case .placeholder(let type):
      imageView.image = .search.resized(24, 24)
      
      titleLabel.isHidden = false
      bookTitleLabel.isHidden = true
      authorLabel.isHidden = true
      
      titleLabel.text = type.title
      bookTitleLabel.text = nil
      authorLabel.text = nil
      
    case .selected(let title, let author):
      imageView.image = .book.resized(24, 24)
      
      titleLabel.isHidden = true
      bookTitleLabel.isHidden = false
      authorLabel.isHidden = false
      
      titleLabel.text = nil
      bookTitleLabel.text = title
      authorLabel.text = author
    }
  }
}

// MARK: - Private
private extension RegisterBookSearchButton {
  /// 버튼 탭 이벤트
  @objc func didTap() {
    onTap?()
  }
}
