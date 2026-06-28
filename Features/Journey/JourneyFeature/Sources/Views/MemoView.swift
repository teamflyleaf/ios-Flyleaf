//
//  MemoView.swift
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

final class MemoView: BaseView {
  var onTapAddMemo: (() -> Void)?
  var onTapMemo: ((JourneyMemo) -> Void)?
  var onLongPressMemo: ((JourneyMemo) -> Void)?
  
  private var memos: [JourneyMemo] = []
  
  private let memoCountSectionTitleLabel = UILabel().then {
    $0.text = "메모(0)"
    $0.font = .b1_sb
    $0.textColor = .n0
  }
  
  private let addMemoButton = UIButton().then {
    $0.setTitle("메모작성", for: .normal)
    $0.setTitleColor(.n0, for: .normal)
    $0.titleLabel?.font = .b1_sb
  }
  
  private let emptyLabel = UILabel().then {
    $0.text = "아직 메모가 비어있어요\n인상 깊은 문장이나 생각을 남겨보세요"
    $0.font = .c3
    $0.textColor = .gray0
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  private let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .clear
    $0.showsVerticalScrollIndicator = false
  }
  
  override func configureUI() {
    [
      memoCountSectionTitleLabel,
      addMemoButton,
      emptyLabel,
      tableView
    ].forEach {
      addSubview($0)
    }
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(
      MemoTableViewCell.self,
      forCellReuseIdentifier: MemoTableViewCell.identifier
    )
    
    let longPressGesture = UILongPressGestureRecognizer(
      target: self,
      action: #selector(didLongPressTableView(_:))
    )
    tableView.addGestureRecognizer(longPressGesture)
    
    bind()
  }
  
  override func setupLayout() {
    memoCountSectionTitleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    
    addMemoButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
    
    emptyLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(memoCountSectionTitleLabel.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  func configure(_ memos: [JourneyMemo]) {
    self.memos = memos
    memoCountSectionTitleLabel.text = "메모(\(memos.count))"
    
    let isEmpty = memos.isEmpty
    emptyLabel.isHidden = !isEmpty
    tableView.isHidden = isEmpty
    
    tableView.reloadData()
  }
}

extension MemoView: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    memos.count
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    1
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {
    20
  }
  
  func tableView(
    _ tableView: UITableView,
    viewForFooterInSection section: Int
  ) -> UIView? {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: MemoTableViewCell.identifier,
      for: indexPath
    ) as? MemoTableViewCell else {
      return UITableViewCell()
    }
    
    cell.configure(memos[indexPath.section])
    return cell
  }
}

extension MemoView: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    onTapMemo?(memos[indexPath.section])
  }
}

// MARK: - Private
private extension MemoView {
  func bind() {
    addMemoButton.addTarget(
      self,
      action: #selector(didTapAddMemo),
      for: .touchUpInside
    )
  }
  
  @objc func didTapAddMemo() {
    onTapAddMemo?()
  }
  
  // 롱프레스
  @objc func didLongPressTableView(_ gesture: UILongPressGestureRecognizer) {
    guard gesture.state == .began else { return }
    
    let location = gesture.location(in: tableView)
    guard let indexPath = tableView.indexPathForRow(at: location) else { return }
    
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.prepare()
    generator.impactOccurred()
    
    let memo = memos[indexPath.section]
    onLongPressMemo?(memo)
  }
}
