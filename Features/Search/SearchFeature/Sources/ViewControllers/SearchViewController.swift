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
  private let recentSearchesView = RecentSearchesView()
  private let searchResultView = SearchResultView()
  
  override public func configureUI() {
    [headerView, dividerView, recentSearchesView, searchResultView].forEach {
      view.addSubview($0)
    }
    
    headerView.searchTextField.delegate = self
    showRecentSearches()
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
    
    recentSearchesView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(22)
      $0.height.equalTo(100)
      $0.width.equalToSuperview()
    }
    
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
    
    recentSearchesView.onTapDeleteAll = { [weak self] in
      self?.viewModel.deleteAllRecentSearch()
    }
    
    recentSearchesView.onTapRecentSearch = { [weak self] qurey in
      self?.headerView.searchTextField.text = qurey
      Task {
        await self?.viewModel.searchBooks(query:qurey)
      }
    }
    
    recentSearchesView.onTapDeleteRecentSearch = { [weak self] qurey in
      self?.viewModel.deleteRecentSearch(qurey)
    }
    
    viewModel.onBooksChanged = { [weak self] books in
      DispatchQueue.main.async {
        let query = self?.headerView.searchTextField.text ?? ""
        
        self?.searchResultView.configure(
          query: query,
          items: books
        )
        
        self?.showSearchResults()
      }
    }
    
    viewModel.onRecentSearchesChanged = { [weak self] recentSearchs in
      DispatchQueue.main.async {
        self?.recentSearchesView.configure(items: recentSearchs)
        
        let text = self?.headerView.searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if text.isEmpty {
          self?.showRecentSearches()
        }
      }
    }
    
    viewModel.loadRecentSearches()
    
    viewModel.onError = { [weak self] message in
      self?.presentAlert(title: "검색 실패", message: message)
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
  
  public func textFieldDidChangeSelection(_ textField: UITextField) {
    let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    
    if text.isEmpty {
      showRecentSearches()
    }
  }
}

// MARK: - Private
private extension SearchViewController {
  private func showRecentSearches() {
    let hasRecentSearches = !viewModel.recentSearches.isEmpty
    recentSearchesView.isHidden = !hasRecentSearches
    searchResultView.isHidden = true
  }

  private func showSearchResults() {
    recentSearchesView.isHidden = true
    searchResultView.isHidden = false
  }
}
