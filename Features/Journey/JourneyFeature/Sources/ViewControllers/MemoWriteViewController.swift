//
//  MemoWriteViewController.swift
//  Journey
//
//  Created by 여성일 on 3/22/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit
import ReadingJourneyInterface

// 메모 작성 바텀시트용 뷰컨트롤러
public final class MemoWriteViewController: BaseViewController {
  public var onTapSave: ((JourneyMemo) -> Void)?
  
  private let book: BookInfo
  private let existingMemo: JourneyMemo?
  
  public init(
    book: BookInfo,
    existingMemo: JourneyMemo? = nil
  ) {
    self.book = book
    self.existingMemo = existingMemo
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.font = .h4_sb
    $0.textColor = .n0
    $0.textAlignment = .center
  }
  
  private let closeButton = UIButton().then {
    $0.setImage(.xmark, for: .normal)
    $0.tintColor = .n0
  }
  
  private let pageSectionTitleLabel = UILabel().then {
    $0.text = "페이지"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let pagePickerField = NeutralPagePickerField()
  
  private let contentSectionTitleLabel = UILabel().then {
    $0.text = "내용"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let contentContainerView = UIView().then {
    $0.backgroundColor = .n20
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
      pageSectionTitleLabel,
      pagePickerField,
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
    
    pageSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(28)
      $0.leading.equalToSuperview().offset(20)
    }
    
    pagePickerField.snp.makeConstraints {
      $0.top.equalTo(pageSectionTitleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(60)
    }
    
    contentSectionTitleLabel.snp.makeConstraints {
      $0.top.equalTo(pagePickerField.snp.bottom).offset(24)
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
private extension MemoWriteViewController {
  // 새 메모 작성인지 수정인지 초기 세팅용
  func configureInitialState() {
    titleLabel.text = existingMemo == nil ? "메모 작성" : "메모 수정"
    
    pagePickerField.configure(
      maxPage: book.itemPage,
      backgroundColor: .n20
    )
    
    if let existingMemo {
      // 메모 있으면 수정모드
      contentTextView.text = existingMemo.content
      pagePickerField.setPage(existingMemo.page)
    } else {
      // 없으면 새 메모 작성 모드
      contentTextView.text = nil
      pagePickerField.clear()
    }
    
    // UI 상태 보정
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
  func makeMemo() -> JourneyMemo? {
    let trimmedContent = contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard !trimmedContent.isEmpty else { return nil }
    
    let now = Date()
    
    if let existingMemo {
      return JourneyMemo(
        id: existingMemo.id,
        content: trimmedContent,
        page: pagePickerField.selectedPage ?? 0,
        createdAt: existingMemo.createdAt,
        updatedAt: now
      )
    } else {
      return JourneyMemo(
        id: UUID().uuidString,
        content: trimmedContent,
        page: pagePickerField.selectedPage ?? 0,
        createdAt: now,
        updatedAt: nil
      )
    }
  }
  
  @objc func didTapClose() {
    dismiss(animated: true)
  }
  
  @objc func didTapSave() {
    guard let memo = makeMemo() else { return }
    onTapSave?(memo)
    dismiss(animated: true)
  }
}

// MARK: - UITextViewDelegate
extension MemoWriteViewController: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    updatePlaceholderVisibility()
    updateSaveButtonState()
  }
}
