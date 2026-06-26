//
//  RegisterHistoryBookView.swift
//  History
//
//  Created by 여성일 on 3/18/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

final class RegisterHistoryBookView: BaseView {
  var onRegisterBookSearchTap: (() -> Void)?
  var onReviewTextChanged: ((String) -> Void)?
  var onStartDateChanged: ((Date) -> Void)?
  var onFinishDateChanged: ((Date) -> Void)?
  var onTapNext: (() -> Void)?
  
  // MARK: - UI
  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
    $0.keyboardDismissMode = .interactive
  }
  
  private let contentView = UIView()
  
  private let headerTitleLabel = UILabel().then {
    $0.font = .h3
    $0.text = "여행을 마쳤나요?"
    $0.textColor = .n0
  }
  
  private let headerSubTitleLabel = UILabel().then {
    $0.font = .b1_m
    $0.text = "다 읽은 책을 추가해보세요"
    $0.textColor = .gray0
  }
  
  private let bookSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "다 읽은 책"
    $0.textColor = .n0
  }
  
  private let button = RegisterBookSearchButton()
  
  private let startSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "시작일"
    $0.textColor = .n0
    $0.isHidden = true
  }
  
  private let startDateField = NeutralDatePickerField(
    placeholder: "시작일을 선택해주세요"
  ).then {
    $0.isHidden = true
  }
  
  private let finishSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "종료일"
    $0.textColor = .n0
    $0.isHidden = true
  }
  
  private let finishDateField = NeutralDatePickerField(
    placeholder: "종료일을 선택해주세요"
  ).then {
    $0.isHidden = true
  }
  
  private let reviewSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "감상평"
    $0.textColor = .n0
    $0.isHidden = true
  }
  
  private let textField = NeutralTextField().then {
    $0.font = .c2
    $0.textColor = .n0
    $0.backgroundColor = .n20
    $0.layer.cornerRadius = 16
    $0.isHidden = true
  }
  
  private let textCountLabel = UILabel().then {
    $0.text = "0/100"
    $0.font = .c3
    $0.textColor = .n0
    $0.isHidden = true
  }
  
  private let nextButton = CTAButton(title: "다음").then {
    $0.isHidden = true
    $0.isEnabled = false
  }
  
  override func configureUI() {
    addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    [
      headerTitleLabel,
      headerSubTitleLabel,
      bookSectionTitleLabel,
      button,
      startSectionTitleLabel,
      startDateField,
      finishSectionTitleLabel,
      finishDateField,
      reviewSectionTitleLabel,
      textField,
      textCountLabel,
      nextButton
    ].forEach {
      contentView.addSubview($0)
    }
    
    backgroundColor = .clear
    
    textField.delegate = self
    textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    
    bind()
    addKeyboardObservers()
  }
  
  override func setupLayout() {
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalTo(scrollView.frameLayoutGuide)
    }
    
    headerTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    headerSubTitleLabel.snp.makeConstraints {
      $0.top.equalTo(headerTitleLabel.snp.bottom).offset(4)
      $0.leading.equalToSuperview()
    }
    
    bookSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(headerSubTitleLabel.snp.bottom).offset(36)
      $0.leading.equalToSuperview()
    }
    
    button.snp.makeConstraints {
      $0.top.equalTo(bookSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    startSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(button.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview()
    }
    
    startDateField.snp.makeConstraints {
      $0.top.equalTo(startSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    finishSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(startDateField.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview()
    }
    
    finishDateField.snp.makeConstraints {
      $0.top.equalTo(finishSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
    }
    
    reviewSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(finishDateField.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview()
    }
    
    textField.snp.makeConstraints {
      $0.top.equalTo(reviewSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(60)
    }
    
    textCountLabel.snp.makeConstraints {
      $0.top.equalTo(textField.snp.bottom).offset(8)
      $0.trailing.equalToSuperview()
    }
    
    nextButton.snp.makeConstraints {
      $0.top.equalTo(textCountLabel.snp.bottom).offset(24)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  // 메모리 해제 시 옵저버 제거
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Public Method
  func configure(_ item: BookInfo) {
    button.configure(
      state: .selected(
        title: item.title,
        author: item.author
      )
    )
    
    startSectionTitleLabel.isHidden = false
    startDateField.isHidden = false
    finishSectionTitleLabel.isHidden = false
    finishDateField.isHidden = false
    reviewSectionTitleLabel.isHidden = false
    textField.isHidden = false
    textCountLabel.isHidden = false
    nextButton.isHidden = false
  }
  
  func setNextButtonEnabled(_ isEnabled: Bool) {
    nextButton.isEnabled = isEnabled
  }
}

// MARK: - Private
private extension RegisterHistoryBookView {
  func bind() {
    button.configure(state: .placeholder(.history))
    
    button.onTap = { [weak self] in
      self?.onRegisterBookSearchTap?()
    }
    
    textField.setPlaceholder("이 책은 어땠나요?", color: .gray0)
    
    startDateField.onDateChanged = { [weak self] date in
      self?.onStartDateChanged?(date)
      self?.finishDateField.minimumDate = date
    }

    finishDateField.onDateChanged = { [weak self] date in
      self?.onFinishDateChanged?(date)
      self?.startDateField.maximumDate = date
    }
  }
  
  func addKeyboardObservers() {
    // 키보드가 올라오기 직전 시스템 노티피케이션 구독
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    // 키보드가 내려가기 직전 시스템 노티피케이션 구독
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  @objc func textDidChange(_ textField: UITextField) {
    let text = textField.text ?? ""
    textCountLabel.text = "\(text.count)/100"
    onReviewTextChanged?(text)
  }
  
  @objc func didTapNext() {
    onTapNext?()
  }
  
  // 키보드 올라올 때
  @objc func keyboardWillShow(_ notification: Notification) {
    guard
      let userInfo = notification.userInfo,
      let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    else { return }
    
    // 키보드의 화면 절대 좌표값
    let keyboardFrame = keyboardFrameValue.cgRectValue
    
    // 키보드 위치를 현재 뷰 기준으로 변환
    let keyboardFrameInSelf = convert(keyboardFrame, from: nil)
    
    // 현재 뷰 하단, bounds.maxY에서 키보드 상단을 뺀 값임. = 키보드가 뷰ㅜ를 가리는 높이
    let bottomInset = max(0, bounds.maxY - keyboardFrameInSelf.minY)
    
    scrollView.contentInset.bottom = bottomInset + 20
    scrollView.scrollIndicatorInsets.bottom = bottomInset + 20
    
    // 텍스트 필드 프레임 변환 후 자동 스크롤
    let textFieldFrame = textField.convert(textField.bounds, to: contentView)
    scrollView.scrollRectToVisible(textFieldFrame.insetBy(dx: 0, dy: -20), animated: true)
  }
  
  // 키보드 내려갈 때
  @objc func keyboardWillHide(_ notification: Notification) {
    // 늘렸던 여백 되돌리기
    scrollView.contentInset.bottom = 0
    scrollView.scrollIndicatorInsets.bottom = 0
  }
}

// MARK: - TextField Delegate
extension RegisterHistoryBookView: UITextFieldDelegate {
  // 글자수 제한 (100글자)
  public func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let currentText = textField.text,
          let textRange = Range(range, in: currentText) else {
      return true
    }
    
    let updatedText = currentText.replacingCharacters(in: textRange, with: string)
    
    return updatedText.count <= 100
  }
}
