//
//  PrivacyPolicyViewController.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import DesignSystem
import SnapKit
import Then
import UIKit
import SettingInterface

public final class PrivacyPolicyViewController: BaseViewController {
  public var onRoute: ((PrivacyPolicyRoute) -> Void)?
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "개인정보 처리방침")
  private let dividerView = DividerView()
  
  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
  }
  private let contentView = UIView()
  
  private let updateLabel = UILabel().then {
    $0.text = PrivacyPolicy.Update.content
    $0.font = .c2
    $0.textColor = .n0
  }
  
  private let outlineTitleLabel = UILabel().then {
    $0.text = PrivacyPolicy.Outline.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let outlineContentLabel = UILabel().then {
    $0.text = PrivacyPolicy.Outline.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section1TitleLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section1.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section1ContentLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section1.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section2TitleLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section2.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section2ContentLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section2.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section3TitleLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section3.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section3ContentLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section3.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section4TitleLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section4.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section4ContentLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section4.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section5TitleLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section5.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section5ContentLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section5.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section6TitleLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section6.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section6ContentLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section6.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section7TitleLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section7.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section7ContentLabel = UILabel().then {
    $0.text = PrivacyPolicy.Section7.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
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
      updateLabel,
      outlineTitleLabel,
      outlineContentLabel,
      section1TitleLabel,
      section1ContentLabel,
      section2TitleLabel,
      section2ContentLabel,
      section3TitleLabel,
      section3ContentLabel,
      section4TitleLabel,
      section4ContentLabel,
      section5TitleLabel,
      section5ContentLabel,
      section6TitleLabel,
      section6ContentLabel,
      section7TitleLabel,
      section7ContentLabel,
    ].forEach {
      contentView.addSubview($0)
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
    
    updateLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    outlineTitleLabel.snp.makeConstraints {
      $0.top.equalTo(updateLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    outlineContentLabel.snp.makeConstraints {
      $0.top.equalTo(outlineTitleLabel.snp.bottom).offset(2)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section1TitleLabel.snp.makeConstraints {
      $0.top.equalTo(outlineContentLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section1ContentLabel.snp.makeConstraints {
      $0.top.equalTo(section1TitleLabel.snp.bottom).offset(2)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section2TitleLabel.snp.makeConstraints {
      $0.top.equalTo(section1ContentLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section2ContentLabel.snp.makeConstraints {
      $0.top.equalTo(section2TitleLabel.snp.bottom).offset(2)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section3TitleLabel.snp.makeConstraints {
      $0.top.equalTo(section2ContentLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section3ContentLabel.snp.makeConstraints {
      $0.top.equalTo(section3TitleLabel.snp.bottom).offset(2)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section4TitleLabel.snp.makeConstraints {
      $0.top.equalTo(section3ContentLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section4ContentLabel.snp.makeConstraints {
      $0.top.equalTo(section4TitleLabel.snp.bottom).offset(2)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section5TitleLabel.snp.makeConstraints {
      $0.top.equalTo(section4ContentLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section5ContentLabel.snp.makeConstraints {
      $0.top.equalTo(section5TitleLabel.snp.bottom).offset(2)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section6TitleLabel.snp.makeConstraints {
      $0.top.equalTo(section5ContentLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section6ContentLabel.snp.makeConstraints {
      $0.top.equalTo(section6TitleLabel.snp.bottom).offset(2)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section7TitleLabel.snp.makeConstraints {
      $0.top.equalTo(section6ContentLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section7ContentLabel.snp.makeConstraints {
      $0.top.equalTo(section7TitleLabel.snp.bottom).offset(2)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(40)
    }
  }
  
  public override func bind() {
    headerView.onTapBack = { [weak self] in
      self?.onRoute?(.back)
    }
  }
}
