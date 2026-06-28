//
//  HistoryViewController.swift
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

public final class HistoryViewController: BaseViewController {
  public var onRoute: ((HistoryRoute) -> Void)?
  
  private let viewModel: HistoryViewModel
  private var isInitialLoading = true
  
  public init(viewModel: HistoryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Task {
      await viewModel.loadFinishedJourneys()
    }
  }
  
  // MARK: - UI
  private let headerTitleLabel = UILabel().then {
    $0.text = "기록"
    $0.font = .h2
    $0.textColor = .n0
  }
  
  private let addHistoryButton = UIButton().then {
    $0.setImage(.plus, for: .normal)
    $0.tintColor = .n0
  }
  
  private let dividerView = DividerView()
  
  private let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .clear
    $0.showsVerticalScrollIndicator = false
  }
  
  private let initialLoadingIndicatorView = UIActivityIndicatorView(style: .large).then {
    $0.color = .n0
    $0.hidesWhenStopped = true
  }
  
  private let emptyView = UIView().then {
    $0.isHidden = true
  }
  
  private let emptyTitleLabel = UILabel().then {
    $0.text = "아직 기록이 없어요"
    $0.font = .b1_sb
    $0.textColor = .n0
    $0.textAlignment = .center
  }
  
  private let emptyDescriptionLabel = UILabel().then {
    $0.text = "다 읽은 책이 생기면 이곳에 기록이 쌓여요"
    $0.font = .c3
    $0.textColor = .gray0
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  public override func configureUI() {
    [
      headerTitleLabel,
      addHistoryButton,
      dividerView,
      tableView,
      initialLoadingIndicatorView,
      emptyView
    ].forEach {
      view.addSubview($0)
    }
    
    [
      emptyTitleLabel,
      emptyDescriptionLabel
    ].forEach {
      emptyView.addSubview($0)
    }
    
    tableView.register(
      HistoryTicketTableViewCell.self,
      forCellReuseIdentifier: HistoryTicketTableViewCell.identifier
    )
    tableView.delegate = self
    tableView.dataSource = self
    
    setContentHidden(true)
    initialLoadingIndicatorView.startAnimating()
  }
  
  public override func setupLayout() {
    headerTitleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    addHistoryButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.trailing.equalToSuperview().inset(20)
      $0.width.height.equalTo(24)
    }
    
    dividerView.snp.makeConstraints {
      $0.top.equalTo(headerTitleLabel.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
    
    initialLoadingIndicatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    emptyView.snp.makeConstraints {
      $0.top.equalTo(headerTitleLabel.snp.bottom).offset(40)
      $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    emptyTitleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-12)
    }
    
    emptyDescriptionLabel.snp.makeConstraints {
      $0.top.equalTo(emptyTitleLabel.snp.bottom).offset(8)
      $0.centerX.equalToSuperview()
      $0.leading.greaterThanOrEqualToSuperview().offset(20)
      $0.trailing.lessThanOrEqualToSuperview().inset(20)
    }
  }
  
  public override func bind() {
    viewModel.onLoadingChanged = { [weak self] isLoading in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        guard self.isInitialLoading else { return }
        
        if isLoading {
          self.setContentHidden(true)
          self.emptyView.isHidden = true
          self.initialLoadingIndicatorView.startAnimating()
        } else {
          self.initialLoadingIndicatorView.stopAnimating()
          self.isInitialLoading = false
        }
      }
    }
    
    viewModel.onJourneysChanged = { [weak self] journeys in
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        
        if journeys.isEmpty {
          self.setEmptyState(true)
          self.tableView.reloadData()
          return
        }
        
        self.setEmptyState(false)
        self.tableView.reloadData()
      }
    }
    
    viewModel.onError = { [weak self] message in
      DispatchQueue.main.async { [weak self] in
        self?.presentAlert(title: "불러오기 실패", message: message)
      }
    }
    
    addHistoryButton.addTarget(self, action: #selector(didAddHistory), for: .touchUpInside)
  }
}

// MARK: - TextField Delegate
extension HistoryViewController: UITableViewDataSource {
  public func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return viewModel.numberOfItems
  }
  
  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: HistoryTicketTableViewCell.identifier,
      for: indexPath
    ) as? HistoryTicketTableViewCell else {
      return UITableViewCell()
    }
    
    let journey = viewModel.journeys[indexPath.row]
    
    cell.configure(
      bookItem: journey.book,
      departure: journey.departureAirport,
      destination: journey.arrivalAirport,
      finishDate: journey.finishedAt ?? journey.createdAt
    )
    
    cell.onLongPressTriggered = { [weak self] in
      self?.presentDeleteAlert(message: "이 여행을 삭제할까요?") { [weak self] in
        Task {
          await self?.viewModel.deleteFinishedJourney(journeyId: journey.id)
        }
      }
    }
    
    return cell
  }
  
  public func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let journey = viewModel.journeys[indexPath.row]
    onRoute?(.detail(journey))
  }
}

extension HistoryViewController: UITableViewDelegate {
  public func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 200
  }
}

// MARK: - Private
private extension HistoryViewController {
  @objc func didAddHistory() {
    onRoute?(.addHistory)
  }
  
  func setContentHidden(_ isHidden: Bool) {
    dividerView.isHidden = isHidden
    tableView.isHidden = isHidden
  }
  
  func setEmptyState(_ isEmpty: Bool) {
    emptyView.isHidden = !isEmpty
    dividerView.isHidden = isEmpty
    tableView.isHidden = isEmpty
  }
}
