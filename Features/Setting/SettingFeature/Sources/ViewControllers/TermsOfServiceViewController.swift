//
//  TermsOfServiceViewController.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import DesignSystem
import SnapKit
import Then
import UIKit
import SettingInterface

public final class TermsOfServiceViewController: BaseViewController {
  public var onRoute: ((TermsOfServiceRoute) -> Void)?
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "서비스 이용약관")
  private let dividerView = DividerView()
  
  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
  }
  private let contentView = UIView()
  
  private let section1TitleLabel = UILabel().then {
    $0.text = TermsOfService.Section1.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section1ContentLabel = UILabel().then {
    $0.text = TermsOfService.Section1.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section2TitleLabel = UILabel().then {
    $0.text = TermsOfService.Section2.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section2ContentLabel = UILabel().then {
    $0.text = TermsOfService.Section2.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section3TitleLabel = UILabel().then {
    $0.text = TermsOfService.Section3.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section3ContentLabel = UILabel().then {
    $0.text = TermsOfService.Section3.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section4TitleLabel = UILabel().then {
    $0.text = TermsOfService.Section4.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section4ContentLabel = UILabel().then {
    $0.text = TermsOfService.Section4.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section5TitleLabel = UILabel().then {
    $0.text = TermsOfService.Section5.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section5ContentLabel = UILabel().then {
    $0.text = TermsOfService.Section5.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section6TitleLabel = UILabel().then {
    $0.text = TermsOfService.Section6.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section6ContentLabel = UILabel().then {
    $0.text = TermsOfService.Section6.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section7TitleLabel = UILabel().then {
    $0.text = TermsOfService.Section7.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section7ContentLabel = UILabel().then {
    $0.text = TermsOfService.Section7.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section8TitleLabel = UILabel().then {
    $0.text = TermsOfService.Section8.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section8ContentLabel = UILabel().then {
    $0.text = TermsOfService.Section8.content
    $0.font = .c2
    $0.textColor = .n0
    $0.numberOfLines = 0
  }
  
  private let section9TitleLabel = UILabel().then {
    $0.text = TermsOfService.Section9.title
    $0.font = .b2_sb
    $0.textColor = .n0
  }
  
  private let section9ContentLabel = UILabel().then {
    $0.text = TermsOfService.Section9.content
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
      section8TitleLabel,
      section8ContentLabel,
      section9TitleLabel,
      section9ContentLabel,
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
    
    section1TitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(22)
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
    }
    
    section8TitleLabel.snp.makeConstraints {
      $0.top.equalTo(section7ContentLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section8ContentLabel.snp.makeConstraints {
      $0.top.equalTo(section8TitleLabel.snp.bottom).offset(2)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section9TitleLabel.snp.makeConstraints {
      $0.top.equalTo(section8ContentLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    section9ContentLabel.snp.makeConstraints {
      $0.top.equalTo(section9TitleLabel.snp.bottom).offset(2)
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
