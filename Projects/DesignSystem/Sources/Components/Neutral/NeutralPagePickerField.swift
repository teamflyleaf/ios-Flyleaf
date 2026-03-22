//
//  NeutralPagePickerField.swift
//  DesignSystem
//
//  Created by 여성일 on 3/19/26.
//

import UIKit
import SnapKit
import Then

public final class NeutralPagePickerField: UIControl {
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: 60)
  }
  
  public var onPageChanged: ((Int) -> Void)?
  
  public var selectedPage: Int? {
    didSet { updateText() }
  }
  
  public var maxPage: Int = 0 {
    didSet {
      pickerView.reloadAllComponents()
      updatePlaceholder()
      
      if let selectedPage, selectedPage > maxPage {
        self.selectedPage = maxPage
        pickerView.selectRow(maxPage, inComponent: 0, animated: false)
      }
    }
  }
  
  private let textField = NeutralTextField().then {
    $0.font = .c2
    $0.textColor = .n0
    $0.backgroundColor = .n60
    $0.layer.cornerRadius = 16
    $0.tintColor = .clear
    $0.clearButtonMode = .never
  }
  
  private let pickerView = UIPickerView()
  private let toolbar = UIToolbar()
  
  public init() {
    super.init(frame: .zero)
    configureUI()
    setupLayout()
    bind()
    updatePlaceholder()
  }
  
  public convenience init(maxPage: Int) {
    self.init()
    self.maxPage = maxPage
    updatePlaceholder()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  public func configure(
    maxPage: Int,
    backgroundColor: UIColor? = nil
  ) {
    self.maxPage = maxPage
    
    if let backgroundColor {
      textField.backgroundColor = backgroundColor
    }
    
    updatePlaceholder()
  }
  
  public func setPage(_ page: Int) {
    let clampedPage = min(max(0, page), maxPage)
    selectedPage = clampedPage
    pickerView.selectRow(clampedPage, inComponent: 0, animated: false)
  }
  
  public func clear() {
    selectedPage = nil
    textField.text = nil
    updatePlaceholder()
  }
}

// MARK: - Private
private extension NeutralPagePickerField {
  func configureUI() {
    addSubview(textField)
    
    pickerView.dataSource = self
    pickerView.delegate = self
    
    textField.inputView = pickerView
    textField.inputAccessoryView = toolbar
    
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
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
    addGestureRecognizer(tap)
  }
  
  func setupLayout() {
    textField.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func bind() {}
  
  func updateText() {
    guard let selectedPage else {
      textField.text = nil
      updatePlaceholder()
      return
    }
    
    textField.text = "\(selectedPage) / \(maxPage)"
  }
  
  func updatePlaceholder() {
    textField.setPlaceholder("0 / \(maxPage)", color: .n20)
  }
  
  @objc func didTap() {
    if let selectedPage {
      pickerView.selectRow(selectedPage, inComponent: 0, animated: false)
    } else {
      pickerView.selectRow(0, inComponent: 0, animated: false)
    }
    textField.becomeFirstResponder()
  }
  
  @objc func didTapDone() {
    let row = pickerView.selectedRow(inComponent: 0)
    selectedPage = row
    onPageChanged?(row)
    sendActions(for: .editingDidEnd)
    textField.resignFirstResponder()
  }
}

// MARK: - UIPickerViewDataSource
extension NeutralPagePickerField: UIPickerViewDataSource {
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  public func pickerView(
    _ pickerView: UIPickerView,
    numberOfRowsInComponent component: Int
  ) -> Int {
    maxPage + 1
  }
}

// MARK: - UIPickerViewDelegate
extension NeutralPagePickerField: UIPickerViewDelegate {
  public func pickerView(
    _ pickerView: UIPickerView,
    titleForRow row: Int,
    forComponent component: Int
  ) -> String? {
    "\(row) / \(maxPage)"
  }
  
  public func pickerView(
    _ pickerView: UIPickerView,
    didSelectRow row: Int,
    inComponent component: Int
  ) {
    selectedPage = row
    onPageChanged?(row)
    sendActions(for: .valueChanged)
  }
}
