//
//  NeutralDatePickerField.swift
//  DesignSystem
//
//  Created by 여성일 on 3/18/26.
//

import UIKit
import Then
import SnapKit

public final class NeutralDatePickerField: UIControl {
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 60)
  }
  
  public var onDateChanged: ((Date) -> Void)?
  
  public var date: Date? {
    didSet { updateText() }
  }
  
  public var minimumDate: Date? {
    didSet { datePicker.minimumDate = minimumDate }
  }
  
  public var maximumDate: Date? {
    didSet { datePicker.maximumDate = maximumDate }
  }
  
  private let textField = NeutralTextField().then {
    $0.font = .c2
    $0.textColor = .n0
    $0.backgroundColor = .n20
    $0.layer.cornerRadius = 16
    $0.tintColor = .clear
  }
  
  private let datePicker = UIDatePicker().then {
    $0.datePickerMode = .date
    $0.preferredDatePickerStyle = .wheels
    $0.locale = Locale(identifier: "ko_KR")
  }
  
  private let formatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "ko_KR")
    f.dateFormat = "yyyy.MM.dd"
    return f
  }()
  
  private let toolbar = UIToolbar()
  
  public init(placeholder: String) {
    super.init(frame: .zero)
    textField.setPlaceholder(placeholder, color: .gray0)
    configureUI()
    setupLayout()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  public func setDate(_ date: Date) {
    self.date = date
    datePicker.setDate(date, animated: false)
  }
  
  public func clear() {
    date = nil
    textField.text = nil
  }
}

// MARK: - Private
private extension NeutralDatePickerField {
  func configureUI() {
    addSubview(textField)
    
    textField.inputView = datePicker
    textField.inputAccessoryView = toolbar
    textField.clearButtonMode = .never
    
    let flexible = UIBarButtonItem(
      barButtonSystemItem: .flexibleSpace,
      target: nil,
      action: nil
    )
    
    let done = UIBarButtonItem(
      title: "완료",
      style: .done,
      target: self,
      action: #selector(didTapDone)
    )
    
    toolbar.items = [flexible, done]
    toolbar.sizeToFit()
    
    // 터치 영역 확장 (UITextField 밖 터치 대응)
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
    addGestureRecognizer(tap)
  }
  
  func setupLayout() {
    textField.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func bind() {
    datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
  }
  
  func updateText() {
    guard let date else {
      textField.text = nil
      return
    }
    
    textField.text = formatter.string(from: date)
  }
  
  @objc func didTap() {
    textField.becomeFirstResponder()
  }
  
  @objc func dateChanged() {
    let selected = datePicker.date
    date = selected
    onDateChanged?(selected)
    sendActions(for: .valueChanged)
  }
  
  @objc func didTapDone() {
    let selected = datePicker.date
    date = selected
    onDateChanged?(selected)
    sendActions(for: .editingDidEnd)
    textField.resignFirstResponder()
  }
}
