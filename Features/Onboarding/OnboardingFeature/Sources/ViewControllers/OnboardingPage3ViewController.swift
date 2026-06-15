//
//  OnboardingPage3ViewController.swift
//  Onboarding
//
//  Created by 여성일 on 6/11/26.
//

import Core
import UIKit
import DesignSystem
import Lottie
import SnapKit
import Then

public final class OnboardingPage3ViewController: BaseViewController {
  public var onCompleted: (() -> Void)?
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.text = "여행은 페이지를 따라 이어져요"
    $0.font = .h2
    $0.textColor = .n0
    $0.textAlignment = .left
  }
  
  private let subtitleLabel = UILabel().then {
    $0.text = "독서가 진행될수록\n여정도 함께 채워집니다."
    $0.font = .c1
    $0.textColor = .n20
    $0.textAlignment = .left
    $0.numberOfLines = 0
  }
  
  private lazy var animationView: LottieAnimationView = {
    let appBundle = Bundle(for: OnboardingPage3ViewController.self)
    let bundle = appBundle.url(forResource: "Onboarding_OnboardingFeature", withExtension: "bundle")
      .flatMap { Bundle(url: $0) } ?? appBundle
    let view = LottieAnimationView(name: "world_map_animation", bundle: bundle)
    view.loopMode = .playOnce
    view.contentMode = .scaleAspectFit
    view.animationSpeed = 2.5
    return view
  }()
  
  // MARK: - Configure
  override public func configureUI() {
    view.backgroundColor = .bg0

    [
      titleLabel,
      subtitleLabel,
      animationView
    ].forEach {
      view.addSubview($0)
    }
    
    animationView.play { [weak self] _ in
      self?.onCompleted?()
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
    
    animationView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(200)
    }
  }
}

