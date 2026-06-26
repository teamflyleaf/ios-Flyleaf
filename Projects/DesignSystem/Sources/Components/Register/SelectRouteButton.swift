//
//  SelectRouteButton.swift
//  DesignSystem
//
//  Created by 여성일 on 3/15/26.
//

import SnapKit
import Then
import UIKit

/// 출발지/도착지 선택 목적에 따라 안내 문구를 정의하는 타입
public enum SelectRouteButtonType {
  case departureAirport
  case arrivalAirport
  
  public var title: String {
    switch self {
    case .departureAirport:
      return "버튼을 눌러 출발지를 등록하세요"
    case .arrivalAirport:
      return "버튼을 눌러 목적지를 등록하세요"
    }
  }
}

/// `SelectRouteButton`의 표시 상태
public enum SelectRouteButtonState {
  case placeholder(SelectRouteButtonType)
  case selected(type: SelectRouteButtonType, iata: String, airport: String)
}

/// 출발지/도착지 공항 선택을 위한 버튼형 UI 컴포넌트 입니다.
///
/// 초기에는 검색 아이콘과 안내 문구를 표시하고,
/// 공항이 선택되면 출발/도착 타입에 맞는 아이콘과 함께
/// IATA 코드 및 공항명을 표시합니다.
///
/// ```swift
/// let button = SelectRouteButton()
/// button.configure(state: .placeholder(.departureAirport))
///
/// button.onTap = {
///   print("공항 검색 화면으로 이동")
/// }
/// ```
///
/// - Note:
///   - Auto Layout 사용 시 별도의 height 제약 없이 intrinsicContentSize를 통해 높이가 결정됩니다.
///   - width는 `noIntrinsicMetric`이므로 반드시 제약으로 설정해야 합니다.
///   - 높이는 60 고정입니다.
///   - 전체 탭 영역은 내부 `contentButton`이 담당합니다.
public final class SelectRouteButton: BaseView {
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
    $0.textColor = .gray0
  }
  
  private let iataLabel = UILabel().then {
    $0.font = .b2_sb
    $0.textColor = .n0
    $0.numberOfLines = 1
  }
  
  private let airportLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .gray0
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
    $0.tintColor = .gray0
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
      iataLabel,
      airportLabel
    ].forEach {
      textStackView.addArrangedSubview($0)
    }
    
    backgroundColor = .n20
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
  public func configure(state: SelectRouteButtonState) {
    switch state {
    case .placeholder(let type):
      imageView.image = .search.resized(24, 24)
      
      titleLabel.isHidden = false
      iataLabel.isHidden = true
      airportLabel.isHidden = true
      
      titleLabel.text = type.title
      iataLabel.text = nil
      airportLabel.text = nil
      
    case .selected(let type, let iata, let airport):
      switch type {
      case .departureAirport:
        imageView.image = .takeOff.resized(24, 24)
      case .arrivalAirport:
        imageView.image = .landing.resized(24, 24)
      }
      
      titleLabel.isHidden = true
      iataLabel.isHidden = false
      airportLabel.isHidden = false
      
      titleLabel.text = nil
      iataLabel.text = iata
      airportLabel.text = airport
    }
  }
}

// MARK: - Private
private extension SelectRouteButton {
  /// 버튼 탭 이벤트
  @objc func didTap() {
    onTap?()
  }
}
