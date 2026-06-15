//
//  OnboardingPage2ViewController.swift
//  Onboarding
//
//  Created by 여성일 on 6/10/26.
//

import Core
import UIKit
import DesignSystem
import SnapKit
import Then

public final class OnboardingPage2ViewController: BaseViewController {
  public var onCompleted: (() -> Void)?
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.text = "여행지를 정해보세요"
    $0.font = .h2
    $0.textColor = .n0
    $0.textAlignment = .left
  }
  
  private let subtitleLabel = UILabel().then {
    $0.text = "독서 여정을 등록할 때\n출발 공항과 도착 공항을 선택하세요"
    $0.font = .c1
    $0.textColor = .n20
    $0.textAlignment = .left
    $0.numberOfLines = 0
  }
  
  private let phoneMockupView = PhoneMockupView()
  
  // MARK: - LifeCycle
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    phoneMockupView.startAutoScroll()
  }
  
  // MARK: - Configure
  override public func configureUI() {
    view.backgroundColor = .bg0
    
    [
      titleLabel,
      subtitleLabel,
      phoneMockupView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  override public func setupLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    subtitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    phoneMockupView.snp.makeConstraints {
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(60)
      $0.horizontalEdges.equalToSuperview().inset(30)
      $0.height.equalTo(phoneMockupView.snp.width).multipliedBy(627.0 / 290.0)
    }
  }
  
  // MARK: - Binding
  public override func bind() {
    phoneMockupView.onScrollCompleted = { [weak self] in
      self?.onCompleted?()
    }
  }
}

