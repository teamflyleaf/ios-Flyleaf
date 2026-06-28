//
//  ThemeSelectionViewController.swift
//  Setting
//
//  Created by 여성일 on 6/28/26.
//

import DesignSystem
import SnapKit
import Then
import UIKit
import SettingInterface

public final class ThemeSelectionViewController: BaseViewController {
  public var onRoute: ((ThemeSelectionRoute) -> Void)?
  
  public init(
  ) {
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "시스템 테마 설정")
  private let dividerView = DividerView()
  
  private let themeSelectionTitleLabel = UILabel().then {
    $0.text = "테마"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let selectionButtonStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 0
  }
  
  private let lightModeButton = NeutralCheckmarkButton(title: "라이트 모드")
  private let darkModeButton = NeutralCheckmarkButton(title: "다크 모드")
  private let systemModeButton = NeutralCheckmarkButton(title: "시스템 설정에 따라")
  
  // MARK: - Configure
  override public func configureUI() {
    [
      headerView,
      dividerView,
      themeSelectionTitleLabel,
      selectionButtonStackView
    ].forEach {
      view.addSubview($0)
    }
    
    [
      lightModeButton,
      darkModeButton,
      systemModeButton
    ].forEach {
      selectionButtonStackView.addArrangedSubview($0)
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
    
    themeSelectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(22)
      $0.leading.equalToSuperview().offset(20)
    }
    
    selectionButtonStackView.snp.makeConstraints {
      $0.top.equalTo(themeSelectionTitleLabel.snp.bottom).offset(16)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  // MARK: - Bind
  override public func bind() {
    headerView.onTapBack = { [weak self] in
      self?.onRoute?(.back)
    }
    
    updateSelection(theme: ThemeManager.currentTheme)
    
    lightModeButton.addTarget(self, action: #selector(didTapLightMode), for: .touchUpInside)
    darkModeButton.addTarget(self, action: #selector(didTapDarkMode), for: .touchUpInside)
    systemModeButton.addTarget(self, action: #selector(didTapSystemMode), for: .touchUpInside)
  }
}

private extension ThemeSelectionViewController {
  @objc private func didTapLightMode() {
    ThemeManager.setTheme(.light, window: view.window)
    updateSelection(theme: .light)
  }
  
  @objc private func didTapDarkMode() {
    ThemeManager.setTheme(.dark, window: view.window)
    updateSelection(theme: .dark)
  }
  
  @objc private func didTapSystemMode() {
    ThemeManager.setTheme(.system, window: view.window)
    updateSelection(theme: .system)
  }
  
  func updateSelection(theme: ThemeMode) {
    lightModeButton.isSelected = theme == .light
    darkModeButton.isSelected = theme == .dark
    systemModeButton.isSelected = theme == .system
  }
}
