//
//  NeutralPagePickerField.swift
//  DesignSystem
//
//  Created by 여성일 on 3/19/26.
//

import UIKit
import SnapKit
import Then

/// 페이지 수를 선택할 수 있는 피커형 입력 컴포넌트입니다.
///
/// 내부적으로 `UITextField`를 사용해 `UIPickerView`를 표시하며,
/// 선택된 페이지를 `"현재 페이지 / 전체 페이지"` 형식으로 보여줍니다.
///
/// ```swift
/// let pagePickerField = NeutralPagePickerField()
/// pagePickerField.configure(maxPage: 320)
/// pagePickerField.setPage(120)
/// pagePickerField.onPageChanged = { page in
///   print("선택된 페이지:", page)
/// }
/// ```
///
/// - Note:
///   - 높이는 60으로 고정입니다.
///   - 사용자가 직접 텍스트를 입력할 수 없고, 피커를 통해서만 값을 선택합니다.
///   - 툴바의 완료 버튼을 누르면 `onPageChanged` 콜백과 `.editingDidEnd` 이벤트가 발생합니다.
///   - 피커를 스크롤하는 동안에는 `onPageChanged` 콜백과 `.valueChanged` 이벤트가 발생합니다.
///   - `presentPicker()`를 호출하면 외부에서도 피커를 직접 띄울 수 있습니다.
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
  
  // MARK: - Public
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
  
  /// 현재 페이지를 설정합니다.
  ///
  /// 전달된 페이지 값은 `0...maxPage` 범위로 보정되며,
  /// 보정된 값이 텍스트와 피커 양쪽에 반영됩니다.
  ///
  /// - Parameter page: 설정할 페이지
  public func setPage(_ page: Int) {
    let clampedPage = min(max(0, page), maxPage)
    selectedPage = clampedPage
    pickerView.selectRow(clampedPage, inComponent: 0, animated: false)
  }
  
  /// 현재 선택된 페이지를 초기화합니다.
  ///
  /// 선택 값을 `nil`로 만들고 텍스트를 비운 뒤 placeholder를 다시 표시합니다.
  public func clear() {
    selectedPage = nil
    textField.text = nil
    updatePlaceholder()
  }
  
  /// 페이지 피커를 화면에 표시합니다.
  ///
  /// 현재 선택된 페이지가 있으면 해당 위치로 피커를 맞추고,
  /// 없으면 0페이지를 기본 선택 상태로 표시합니다.
  public func presentPicker() {
    if let selectedPage {
      pickerView.selectRow(selectedPage, inComponent: 0, animated: false)
    } else {
      pickerView.selectRow(0, inComponent: 0, animated: false)
    }
    textField.becomeFirstResponder()
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
    presentPicker()
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
