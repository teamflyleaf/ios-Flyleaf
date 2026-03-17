//
//  RegisterProgressView.swift
//  Wishlist
//
//  Created by 여성일 on 3/16/26.
//

import Core
import SnapKit
import Then
import UIKit

/// 여행 등록 플로우 진행 단계를 보여주는 프로그레스 컴포넌트 입니다.
///
/// 총 3단계의 막대로 구성되어있고, 현재 진행 단계까지 `.key0` 색상으로 표시됩니다.
///
/// ```swift
/// let progressView = NeutralProgressView()
/// progressView.configure(step: .route)
/// ```
public final class NeutralProgressView: BaseView {
  /// 여행 등록 플로우 단계
  public enum Step {
    /// 책 정보 입력 단계
    case book
    
    /// 출발지와 도착지 선택 단계
    case route
    
    /// 최종 확인 단계
    case check
  }
  
  // MARK: - UI
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 4
    $0.distribution = .fillEqually
    $0.alignment = .fill
  }
  
  private let bookStepView = UIView().then {
    $0.backgroundColor = .n50
    $0.layer.cornerRadius = 2
    $0.clipsToBounds = true
  }
  
  private let routeStepView = UIView().then {
    $0.backgroundColor = .n50
    $0.layer.cornerRadius = 2
    $0.clipsToBounds = true
  }
  
  private let checkStepView = UIView().then {
    $0.backgroundColor = .n50
    $0.layer.cornerRadius = 2
    $0.clipsToBounds = true
  }
  
  public override func configureUI() {
    addSubview(stackView)
    
    [
      bookStepView,
      routeStepView,
      checkStepView
    ].forEach {
      stackView.addArrangedSubview($0)
    }
    
    backgroundColor = .clear
  }
  
  public override func setupLayout() {
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(4)
    }
  }
  
  // MARK: - Public Method
  public func configure(step: Step) {
    UIView.animate(
      withDuration: 0.25,
      delay: 0,
      options: .curveEaseOut
    ) {
      switch step {
      case .book:
        self.bookStepView.backgroundColor = .key0
        self.routeStepView.backgroundColor = .n50
        self.checkStepView.backgroundColor = .n50
    
      case .route:
        self.bookStepView.backgroundColor = .key0
        self.routeStepView.backgroundColor = .key0
        self.checkStepView.backgroundColor = .n50
        
      case .check:
        self.bookStepView.backgroundColor = .key0
        self.routeStepView.backgroundColor = .key0
        self.checkStepView.backgroundColor = .key0
      }
    }
  }
}
