//
//  DetailHistoryViewController.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit
import HistoryInterface

public final class DetailHistoryViewController: BaseViewController {
  public var onRoute: ((DetailHistoryRoute) -> Void)?
  
  private let viewModel: DetailHistoryViewModel
  
  public init(viewModel: DetailHistoryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "기록")
  private let dividerView = DividerView()
  private let detailHistoryView = DetailHistoryView()
  
  public override func configureUI() {
    [
      headerView,
      dividerView,
      detailHistoryView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  public override func setupLayout() {
    headerView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.width.equalToSuperview()
    }
    
    dividerView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
    }
    
    detailHistoryView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
  }
  
  public override func bind() {
    detailHistoryView.configure(viewModel.journey)
    
    headerView.onTapBack = { [weak self] in
      self?.onRoute?(.back)
    }
  }
}
