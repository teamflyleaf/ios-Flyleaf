//
//  RegisterWish.swift
//  Wishlist
//
//  Created by 여성일 on 3/13/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

final class RegisterWishBookView: BaseView {
  var onRegisterBookSearchTap: (() -> Void)?
  var onReasonTextChanged: ((String) -> Void)?
  var onTapNext: (() -> Void)?
  
  // MARK: - UI
  private let headerTitleLabel = UILabel().then {
    $0.font = .h3
    $0.text = "다음 여행을 준비해볼까요?"
    $0.textColor = .n0
  }
  
  private let headerSubTitleLabel = UILabel().then {
    $0.font = .b1_m
    $0.text = "읽고 싶은 책을 찾아보세요"
    $0.textColor = .gray0
  }
  
  private let bookSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "읽고 싶은 책"
    $0.textColor = .n0
  }
  
  private let button = RegisterBookSearchButton()
  
  private let reasonSectionTitleLabel = UILabel().then {
    $0.font = .b1_sb
    $0.text = "읽고 싶은 이유"
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
    $0.text = "0/30"
    $0.font = .c3
    $0.textColor = .n0
    $0.isHidden = true
  }
  
  private let nextButton = CTAButton(title: "다음").then {
    $0.isHidden = true
  }
  
  override func configureUI() {
    [
      headerTitleLabel,
      headerSubTitleLabel,
      bookSectionTitleLabel,
      button,
      reasonSectionTitleLabel,
      textField,
      textCountLabel,
      nextButton
    ].forEach {
      addSubview($0)
    }
    backgroundColor = .clear
    
    textField.delegate = self
    textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    bind()
  }
  
  override func setupLayout() {
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
    
    reasonSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(button.snp.bottom).offset(32)
      $0.horizontalEdges.equalToSuperview()
    }
    
    textField.snp.makeConstraints {
      $0.top.equalTo(reasonSectionTitleLabel.snp.bottom).offset(14)
      $0.horizontalEdges.equalToSuperview()
      $0.height.equalTo(60)
    }
    
    textCountLabel.snp.makeConstraints {
      $0.top.equalTo(textField.snp.bottom).offset(8)
      $0.trailing.equalToSuperview()
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  func configure(_ item: BookInfo) {
    button.configure(
      state:.selected(
        title: item.title,
        author: item.author
      )
    )
    
    reasonSectionTitleLabel.isHidden = false
    textField.isHidden = false
    textCountLabel.isHidden = false
    nextButton.isHidden = false
  }
}

// MARK: - Private
private extension RegisterWishBookView {
  func bind() {
    button.configure(state: .placeholder(.wishlist))
    button.onTap = { [weak self] in
      self?.onRegisterBookSearchTap?()
    }
    
    textField.setPlaceholder("왜 이 책을 읽고 싶나요?", color: .gray0)
  }
  
  @objc func textDidChange(_ textField: UITextField) {
    let text = textField.text ?? ""
    textCountLabel.text = "\(text.count)/30"
    onReasonTextChanged?(text)
  }
  
  @objc func didTapNext() {
    onTapNext?()
  }
}

// MARK: - TextField Delegate
extension RegisterWishBookView: UITextFieldDelegate {
  // 글자수 제한 (30글자)
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
    
    return updatedText.count <= 30
  }
}
