//
//  SearchResultView.swift
//  Search
//
//  Created by 여성일 on 3/12/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

final class SearchResultView: BaseView {
  var onTapItem: ((BookSearchItem) -> Void)?
  var onReachedBottom: (() -> Void)?
  
  private var items: [BookSearchItem] = []
  
  // MARK: - UI
  private let resultCountLabel = UILabel().then {
    $0.font = .b2_m
    $0.textColor = .n20
    $0.numberOfLines = 1
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: createLayout()
  ).then {
    $0.backgroundColor = .clear
    $0.showsVerticalScrollIndicator = false
    $0.keyboardDismissMode = .onDrag
    $0.dataSource = self
    $0.delegate = self
    $0.register(
      BookSearchResultCell.self,
      forCellWithReuseIdentifier: BookSearchResultCell.identifier
    )
  }
  
  override func configureUI() {
    [resultCountLabel, collectionView].forEach {
      addSubview($0)
    }
    backgroundColor = .clear
  }
  
  override func setupLayout() {
    resultCountLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview().offset(18)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(resultCountLabel.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
  }
  
  // MARK: Public Method
  func configure(
    query: String,
    items: [BookSearchItem]
  ) {
    self.items = items
    resultCountLabel.text = "'\(query)' 관련 결과 \(items.count)개"
    
    collectionView.reloadData()
  }
}

// MARK: - Private
private extension SearchResultView {
  func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 16
    layout.minimumInteritemSpacing = 0
    return layout
  }
}

// MARK: - CollectionView Delegate
extension SearchResultView: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    items.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: BookSearchResultCell.identifier,
      for: indexPath
    ) as? BookSearchResultCell else {
      return UICollectionViewCell()
    }
    
    let item = items[indexPath.item]
    
    cell.configure(item: item)
    return cell
  }
}

extension SearchResultView: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    onTapItem?(items[indexPath.item])
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard indexPath.item == items.count - 1 else { return }
    onReachedBottom?()
  }
}

extension SearchResultView: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(
      width: collectionView.bounds.width,
      height: 132
    )
  }
}

