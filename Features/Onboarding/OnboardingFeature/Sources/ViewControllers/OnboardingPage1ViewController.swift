//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by 여성일 on 6/10/26.
//

import Core
import UIKit
import DesignSystem
import SnapKit
import Then

public final class OnboardingViewController: BaseViewController {
  private let viewModel: OnboardingViewModel
  
  public init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let scriptStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .center
    $0.spacing = 12
  }
  
  private let script1 = UILabel().then {
    $0.text = "책 한 권은 하나의 여행입니다."
    $0.font = .h2
    $0.textColor = .n0
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.alpha = 0
  }
  
  private let script2 = UILabel().then {
    $0.text = "읽기 전 설렘부터\n마지막 페이지의 여운까지"
    $0.font = .h2
    $0.textColor = .n0
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.alpha = 0
    $0.isHidden = true
  }
  
  private let script3 = UILabel().then {
    $0.text = "당신의 독서 여정을\n기록해 보세요"
    $0.font = .h2
    $0.textColor = .n0
    $0.textAlignment = .center
    $0.numberOfLines = 0
    $0.alpha = 0
    $0.isHidden = true
  }
  
  // MARK: - Lifecycle
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    Task { [weak self] in
      await self?.playSequence()
    }
  }
  
  // MARK: - Configure
  override public func configureUI() {
    view.backgroundColor = .bg0
    
    view.addSubview(scriptStackView)
    
    [
      script1,
      script2,
      script3
    ].forEach {
      scriptStackView.addArrangedSubview($0)
    }
  }
  
  override public func setupLayout() {
    scriptStackView.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
  
  // MARK: - Binding
  public override func bind() {
    
  }
}

// MARK: - Private
private extension OnboardingViewController {
  func showScript(_ label: UILabel?) {
    guard let label else { return }
    label.alpha = 0
    
    UIView.animate(withDuration: 0.35) {
      label.isHidden = false
      label.alpha = 1
      self.view.layoutIfNeeded()
    }
  }
  
  func playSequence() async {
    DispatchQueue.main.async { self.showScript(self.script1) }
    try? await Task.sleep(for: .seconds(1))
    DispatchQueue.main.async {
      self.changeColor(of: [self.script1], to: .n50)
      self.showScript(self.script2)
    }
    try? await Task.sleep(for: .seconds(1))
    DispatchQueue.main.async {
      self.changeColor(of: [self.script1, self.script2], to: .n50)
      self.showScript(self.script3)
    }
  }
  
  func changeColor(of labels: [UILabel], to color: UIColor) {
    labels.forEach { label in
      UIView.transition(with: label, duration: 0.4, options: .transitionCrossDissolve) {
        label.textColor = color
      }
    }
  }
}
