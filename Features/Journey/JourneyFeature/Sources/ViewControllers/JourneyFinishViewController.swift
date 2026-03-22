//
//  JourneyFinishViewController.swift
//  Journey
//
//  Created by 여성일 on 3/22/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

/// 독서 완료 시 감상평을 입력받는 바텀시트용 뷰컨트롤러입니다.
public final class JourneyFinishViewController: BaseViewController {
  public var onTapComplete: ((String) -> Void)?
  
  private let existingReview: String?
  
  public init(existingReview: String? = nil) {
    self.existingReview = existingReview
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.text = "감상평 작성"
    $0.font = .h4_sb
    $0.textColor = .n0
    $0.textAlignment = .center
  }
  
  private let closeButton = UIButton().then {
    $0.setImage(.xmark, for: .normal)
    $0.tintColor = .n0
  }
  
  private let reviewSectionTitleLabel = UILabel().then {
    $0.text = "감상평"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let reviewContainerView = UIView().then {
    $0.backgroundColor = .n50.withAlphaComponent(0.6)
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
  }
  
  private let reviewTextView = UITextView().then {
    $0.backgroundColor = .clear
    $0.font = .c2
    $0.textColor = .n0
    $0.tintColor = .key0
    $0.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
  }
  
  private let placeholderLabel = UILabel().then {
    $0.text = "이 책을 읽고 든 생각이나 감상을 남겨보세요"
    $0.font = .c2
    $0.textColor = .n20
    $0.numberOfLines = 1
  }
  
  private let completeButton = CTAButton(title: "완료")
  
  public override func configureUI() {
    view.layer.masksToBounds = true
    view.backgroundColor = .clear
    
    [
      titleLabel,
      closeButton,
      reviewSectionTitleLabel,
      reviewContainerView,
      completeButton
    ].forEach {
      view.addSubview($0)
    }
    
    [
      reviewTextView,
      placeholderLabel
    ].forEach {
      reviewContainerView.addSubview($0)
    }
    
    configureInitialState()
  }
  
  public override func setupLayout() {
    closeButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
      $0.trailing.equalToSuperview().inset(20)
      $0.size.equalTo(24)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
      $0.centerX.equalToSuperview()
    }
    
    reviewSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(28)
      $0.leading.equalToSuperview().offset(20)
    }
    
    reviewContainerView.snp.makeConstraints {
      $0.top.equalTo(reviewSectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(260)
    }
    
    reviewTextView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    placeholderLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.equalToSuperview().offset(17)
      $0.trailing.lessThanOrEqualToSuperview().inset(16)
    }
    
    completeButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
  public override func bind() {
    closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    completeButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
    reviewTextView.delegate = self
  }
}

// MARK: - Private
private extension JourneyFinishViewController {
  func configureInitialState() {
    reviewTextView.text = existingReview
    updatePlaceholderVisibility()
    updateCompleteButtonState()
  }
  
  func updatePlaceholderVisibility() {
    let trimmedText = reviewTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    placeholderLabel.isHidden = !trimmedText.isEmpty
  }
  
  func updateCompleteButtonState() {
    let trimmedText = reviewTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    completeButton.isEnabled = !trimmedText.isEmpty
  }
  
  func makeReview() -> String? {
    let trimmedText = reviewTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedText.isEmpty ? nil : trimmedText
  }
  
  @objc func didTapClose() {
    dismiss(animated: true)
  }
  
  @objc func didTapComplete() {
    guard let review = makeReview() else { return }
    onTapComplete?(review)
    dismiss(animated: true)
  }
}

// MARK: - UITextViewDelegate
extension JourneyFinishViewController: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    updatePlaceholderVisibility()
    updateCompleteButtonState()
  }
}
