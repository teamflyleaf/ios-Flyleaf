//
//  HomeViewController.swift
//  Home
//
//  Created by 여성일 on 3/6/26.
//

import UIKit
import DesignSystem
import SnapKit
import Then

public final class HomeViewController: BaseViewController {
  private let viewModel: HomeViewModel
  
  public init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let label = UILabel().then {
    $0.text = "Home"
    $0.font = .h1
  }
  
  override public func configureUI() {
    [label].forEach {
      view.addSubview($0)
    }
  }
  
  override public func setupLayout() {
    label.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
}
