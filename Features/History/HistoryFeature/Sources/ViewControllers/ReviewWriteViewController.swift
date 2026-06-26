//
//  ReviewWriteViewController.swift
//  History
//
//  Created by 여성일 on 4/2/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

// 감상평 업데이트 바텀시트용 뷰컨트롤러
public final class ReviewWriteViewController: BaseViewController {
  public var onTapSave: ((String) -> Void)?

  private let book: BookInfo
  private let existingReview: String?
  
  public init(
    book: BookInfo,
    existingReview: String? = nil
  ) {
    self.book = book
    self.existingReview = existingReview
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.text = "감상평 수정"
    $0.font = .h4_sb
    $0.textColor = .n0
    $0.textAlignment = .center
  }
  
  private let closeButton = UIButton().then {
    $0.setImage(.xmark, for: .normal)
    $0.tintColor = .n0
  }

  private let contentSectionTitleLabel = UILabel().then {
    $0.text = "내용"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let contentContainerView = UIView().then {
    $0.backgroundColor = .n20.withAlphaComponent(0.6)
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
  }
  
  private let contentTextView = UITextView().then {
    $0.backgroundColor = .clear
    $0.font = .c2
    $0.textColor = .n0
    $0.tintColor = .key0
    $0.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
  }
  
  private let placeholderLabel = UILabel().then {
    $0.text = "인상 깊은 문장이나 생각을 남겨보세요"
    $0.font = .c2
    $0.textColor = .gray0
    $0.numberOfLines = 1
  }
  
  private let saveButton = CTAButton(title: "저장")
  
  public override func configureUI() {
    view.layer.masksToBounds = true
    view.backgroundColor = .clear
    [
      titleLabel,
      closeButton,
      contentSectionTitleLabel,
      contentContainerView,
      saveButton
    ].forEach {
      view.addSubview($0)
    }
    
    [
      contentTextView,
      placeholderLabel
    ].forEach {
      contentContainerView.addSubview($0)
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
    
    contentSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(28)
      $0.leading.equalToSuperview().offset(20)
    }
    
    contentContainerView.snp.makeConstraints {
      $0.top.equalTo(contentSectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(220)
    }
    
    contentTextView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    placeholderLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.equalToSuperview().offset(17)
      $0.trailing.lessThanOrEqualToSuperview().inset(16)
    }
    
    saveButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
  public override func bind() {
    closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
    contentTextView.delegate = self
  }
}

// MARK: - Private
private extension ReviewWriteViewController {
  // 새 메모 작성인지 수정인지 초기 세팅용
  func configureInitialState() {
    contentTextView.text = existingReview ?? ""
    updatePlaceholderVisibility()
    updateSaveButtonState()
  }
  
  // 텍스트뷰 플레이스홀더
  func updatePlaceholderVisibility() {
    let trimmedText = contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    placeholderLabel.isHidden = !trimmedText.isEmpty
  }
  
  // 버튼 활성화 여부
  func updateSaveButtonState() {
    let trimmedText = contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    let isEnabled = !trimmedText.isEmpty
    
    saveButton.isEnabled = isEnabled
  }
  
  // 화면 입력값 조립 용 메소드
  func makeReview() -> String? {
    let trimmedReview = contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedReview.isEmpty ? nil : trimmedReview
  }
  
  @objc func didTapClose() {
    dismiss(animated: true)
  }
  
  @objc func didTapSave() {
    guard let review = makeReview() else { return }
    onTapSave?(review)
    dismiss(animated: true)
  }
}

// MARK: - UITextViewDelegate
extension ReviewWriteViewController: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    updatePlaceholderVisibility()
    updateSaveButtonState()
  }
}
