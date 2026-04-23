//
//  OpenSourceViewController.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

import DesignSystem
import SnapKit
import Then
import UIKit
import SettingInterface

public final class OpenSourceViewController: BaseViewController {
  public var onRoute: ((OpenSourceRoute) -> Void)?
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "오픈 소스")
  private let dividerView = DividerView()
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
  }
  
  private let aladinAPIButton = SettingInfoButton(title: "AladinAPI")
  private let firebaseButton = SettingInfoButton(title: "Firebase")
  private let kingfisherButton = SettingInfoButton(title: "Kingfisher")
  private let snapkitButton = SettingInfoButton(title: "SnapKit")
  private let thenButton = SettingInfoButton(title: "Then")
  private let tuistButton = SettingInfoButton(title: "Tuist")
  
  // MARK: - Configure
  override public func configureUI() {
    [
      headerView,
      dividerView,
      stackView
    ].forEach {
      view.addSubview($0)
    }
    
    [
      aladinAPIButton,
      firebaseButton,
      kingfisherButton,
      snapkitButton,
      thenButton,
      tuistButton
    ].forEach {
      stackView.addArrangedSubview($0)
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
    
    stackView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  public override func bind() {
    headerView.onTapBack = { [weak self] in
      self?.onRoute?(.back)
    }
    
    buttonBind()
  }
}

// MARK: - Private
private extension OpenSourceViewController {
  func buttonBind() {
    aladinAPIButton.onTap = {
      UIApplication.shared.open(OpenSourceURL.aladin)
    }
    
    firebaseButton.onTap = {
      UIApplication.shared.open(OpenSourceURL.firebase)
    }
    
    kingfisherButton.onTap = {
      UIApplication.shared.open(OpenSourceURL.kingfisher)
    }
    
    snapkitButton.onTap = {
      UIApplication.shared.open(OpenSourceURL.snapkit)
    }
    
    thenButton.onTap = {
      UIApplication.shared.open(OpenSourceURL.then)
    }
    
    tuistButton.onTap = {
      UIApplication.shared.open(OpenSourceURL.tuist)
    }
  }
}
