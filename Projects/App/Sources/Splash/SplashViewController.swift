//
//  SplashViewController.swift
//  App
//
//  Created by 여성일 on 5/30/26.
//

import DesignSystem
import SnapKit
import Then
import UIKit

final class SplashViewController: BaseViewController {
  private let viewModel: SplashViewModel
  
  var onRoute: ((SplashResult) -> Void)?
  
  init(viewModel: SplashViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let logoImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = .flyleafLogo
    $0.tintColor = .n10
  }
  
  private let loadingStepDisplayLabel = UILabel().then {
    $0.font = .b1_m
    $0.textColor = .n0
    $0.textAlignment = .center
  }
  
  override func configureUI() {
    [logoImage, loadingStepDisplayLabel].forEach {
      view.addSubview($0)
    }

    view.backgroundColor = .key0
  }
  
  override func setupLayout() {
    logoImage.snp.makeConstraints {
      $0.width.height.equalTo(300)
      $0.centerX.centerY.equalToSuperview()
    }
    
    loadingStepDisplayLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
  // MARK: - Bind
  override func bind() {
    viewModel.onStepChanged = { [weak self] step in
      DispatchQueue.main.async {
        self?.loadingStepDisplayLabel.text = step.displayText
      }
    }
    
    viewModel.onCompleted = { [weak self] result in
      DispatchQueue.main.async {
        self?.onRoute?(result)
      }
    }
    
    Task {
      await viewModel.startLoading()
    }
  }
}
