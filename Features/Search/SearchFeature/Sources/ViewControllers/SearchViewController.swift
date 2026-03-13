//
//  SearchViewController.swift
//  Search
//
//  Created by 여성일 on 3/11/26.
//

import DesignSystem
import MapKit
import SnapKit
import Then
import UIKit

public final class SearchViewController: BaseViewController {
  public var onTapBack: (() -> Void)?
  
  private let viewModel: SearchViewModel
  
  public init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    headerView.searchTextField.becomeFirstResponder()
  }
  
  // MARK: - UI
  private let headerView = SearchHeader()
  private let dividerView = DividerView()
  private let recentSearchsView = RecentSearchsView()
  private let searchResultView = SearchResultView()
  
  override public func configureUI() {
    [headerView, dividerView, searchResultView].forEach {
      view.addSubview($0)
    }
    
    headerView.searchTextField.delegate = self
  }
  
  override public func setupLayout() {
    headerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.width.equalToSuperview()
    }
    
    dividerView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(22)
      $0.width.equalToSuperview()
    }
    
    //    recentSearchsView.snp.makeConstraints {
    //      $0.top.equalTo(dividerView.snp.bottom).offset(22)
    //      $0.width.equalToSuperview()
    //    }
    
    searchResultView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(22)
      $0.bottom.equalToSuperview().inset(22)
      $0.width.equalToSuperview()
    }
  }
  
  override public func bind() {
    headerView.onTapBack = { [weak self] in
      self?.onTapBack?()
    }
    
    headerView.setPlaceholder(viewModel.placeholder)

    viewModel.onBooksChanged = { [weak self] books in
      DispatchQueue.main.async {
        let query = self?.headerView.searchTextField.text ?? ""
        
        self?.searchResultView.configure(
          query: query,
          items: books
        )
      }
    }
    
    viewModel.onError = { [weak self] error in
      print(error)
    }
    
    searchResultView.onReachedBottom = { [weak self] in
      Task {
        await self?.viewModel.loadNextPage()
      }
    }
  }
}

// MARK: - TextField Delegate
extension SearchViewController: UITextFieldDelegate {
  // 글자수 제한 (20글자)
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
    
    return updatedText.count <= 20
  }
  
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text?.trimmingCharacters(in: .whitespaces),
          !text.isEmpty else { return true }
    
    Task { [weak self] in
      await self?.viewModel.searchBooks(query: text)
    }
    
    textField.resignFirstResponder()
    return true
  }
}
