//
//  SettingViewController.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import DesignSystem
import SnapKit
import Then
import UIKit
import SettingInterface

public final class SettingViewController: BaseViewController {
  public var onRoute: ((SettingRoute) -> Void)?
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "설정")
  private let dividerView = DividerView()
  
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  
  private let socialTitleLabel = UILabel().then {
    $0.text = "소셜 계정"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let socialEmailLabel = NeutralPaddingLabel().then {
    $0.text = "seongil_yeo@naver.com"
    $0.font = .c2
    $0.textColor = .n0
    $0.backgroundColor = .n60
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
    $0.numberOfLines = 1
  }
  
  private let logoutButton = CTAButton(title: "로그아웃")
  private let deleteAccountButton = CTAButton(title: "회원탈퇴")
  
  private let socialButtonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.spacing = 6
  }
  
  private let infoSectionDividerView = DividerView()
  
  private let infoTitleLabel = UILabel().then {
    $0.text = "정보"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let appVersionTitleLabel = UILabel().then {
    $0.text = "앱 버전"
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let appVersionLabel = UILabel().then {
    $0.text = "1.1.0"
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let appVersionStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .equalSpacing
  }
  
  private let infoStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
  }
  
  private let privacyPolicyButton = SettingInfoButton(title: "개인정보 처리방침")
  private let termsOfServiceButton = SettingInfoButton(title: "서비스 이용약관")
  private let openSourceButton = SettingInfoButton(title: "오픈 소스")
  
  private let reportSectionDividerView = DividerView()
  
  private let reportTitleLabel = UILabel().then {
    $0.text = "리포트"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let reportStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
  }
  
  private let bugReportButton = SettingInfoButton(title: "버그 신고")
  private let qnaButton = SettingInfoButton(title: "기타 문의")
  
  // MARK: - Configure
  override public func configureUI() {
    [
      headerView,
      dividerView,
      scrollView
    ].forEach {
      view.addSubview($0)
    }
    
    scrollView.addSubview(contentView)
    
    [
      socialTitleLabel,
      socialEmailLabel,
      socialButtonStackView,
      infoSectionDividerView,
      infoTitleLabel,
      appVersionStackView,
      infoStackView,
      reportSectionDividerView,
      reportTitleLabel,
      reportStackView
    ].forEach {
      contentView.addSubview($0)
    }
    
    [
      logoutButton,
      deleteAccountButton
    ].forEach {
      socialButtonStackView.addArrangedSubview($0)
    }
    
    [
      appVersionTitleLabel,
      appVersionLabel
    ].forEach {
      appVersionStackView.addArrangedSubview($0)
    }
    
    [
      privacyPolicyButton,
      termsOfServiceButton,
      openSourceButton
    ].forEach {
      infoStackView.addArrangedSubview($0)
    }
    
    [
      bugReportButton,
      qnaButton
    ].forEach {
      reportStackView.addArrangedSubview($0)
    }
  }
  
  // MARK: - Layout
  override public func setupLayout() {
    headerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.width.equalToSuperview()
    }
    
    dividerView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(22)
      $0.width.equalToSuperview()
    }
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    socialTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(22)
      $0.leading.equalToSuperview().offset(20)
    }
    
    socialEmailLabel.snp.makeConstraints {
      $0.top.equalTo(socialTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    socialButtonStackView.snp.makeConstraints {
      $0.top.equalTo(socialEmailLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    infoSectionDividerView.snp.makeConstraints {
      $0.top.equalTo(socialButtonStackView.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    infoTitleLabel.snp.makeConstraints {
      $0.top.equalTo(infoSectionDividerView.snp.bottom).offset(22)
      $0.leading.equalToSuperview().offset(20)
    }
    
    appVersionStackView.snp.makeConstraints {
      $0.top.equalTo(infoTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(30)
    }
    
    infoStackView.snp.makeConstraints {
      $0.top.equalTo(appVersionStackView.snp.bottom).offset(16)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    reportSectionDividerView.snp.makeConstraints {
      $0.top.equalTo(infoStackView.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    reportTitleLabel.snp.makeConstraints {
      $0.top.equalTo(reportSectionDividerView.snp.bottom).offset(22)
      $0.leading.equalToSuperview().offset(20)
    }
    
    reportStackView.snp.makeConstraints {
      $0.top.equalTo(reportTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(40)
    }
  }
  
  // MARK: - Bind
  override public func bind() {
    headerView.onTapBack = { [weak self] in
      self?.onRoute?(.back)
    }
    
    infoButtonBind()
    reportButtonBind()
  }
}

// MARK: - Private
private extension SettingViewController {
  func infoButtonBind() {
    privacyPolicyButton.onTap = { [weak self] in
      self?.onRoute?(.privacyPolicy)
    }
    
    termsOfServiceButton.onTap = { [weak self] in
      self?.onRoute?(.termsOfService)
    }
  }
  
  func reportButtonBind() {
    
  }
}
