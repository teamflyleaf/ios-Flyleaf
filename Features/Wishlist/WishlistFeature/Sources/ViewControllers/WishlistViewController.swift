//
//  WishlistViewController.swift
//  Wishlist
//
//  Created by 여성일 on 3/13/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit
import WishlistInterface

public final class WishlistViewController: BaseViewController {
  public var onRoute: ((WishlistRoute) -> Void)?
  
  private let viewModel: WishlistViewModel
  private var isInitialLoading = true
  
  public init(viewModel: WishlistViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    Task { [weak self] in
      await self?.viewModel.loadWishlistJourneys()
    }
  }
  
  // MARK: - UI
  private let headerTitleLabel = UILabel().then {
    $0.text = "예약"
    $0.font = .h2
    $0.textColor = .n0
  }
  
  private let addWishButton = UIButton().then {
    $0.setImage(.plus, for: .normal)
    $0.tintColor = .n0
  }
  
  private let dividerView = DividerView()
  
  private let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .clear
    $0.showsVerticalScrollIndicator = false
  }
  
  private let swipeTooltipView = NeutralTooltipView(tailPosition: .topLeft).then {
    $0.configure(tip: "오른쪽으로 밀어 체크인할 수 있어요")
    $0.isHidden = true
  }
  
  private let initialLoadingIndicatorView = UIActivityIndicatorView(style: .large).then {
    $0.color = .n0
    $0.hidesWhenStopped = true
  }
  
  private let emptyView = UIView().then {
    $0.isHidden = true
  }
  
  private let emptyTitleLabel = UILabel().then {
    $0.text = "아직 예약이 없어요"
    $0.font = .b1_sb
    $0.textColor = .n0
    $0.textAlignment = .center
  }
  
  private let emptyDescriptionLabel = UILabel().then {
    $0.text = "읽고 싶은 책을 예약하면 이곳에 쌓여요"
    $0.font = .c3
    $0.textColor = .n20
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  public override func configureUI() {
    [
      headerTitleLabel,
      addWishButton,
      dividerView,
      tableView,
      initialLoadingIndicatorView,
      emptyView,
      swipeTooltipView
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
      WishTicketTableViewCell.self,
      forCellReuseIdentifier: WishTicketTableViewCell.identifier
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
    
    addWishButton.snp.makeConstraints {
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
    
    swipeTooltipView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(268)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.lessThanOrEqualToSuperview().inset(20)
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
        self.viewModel.checkWishlistSwipeTooltip()
      }
    }
    
    viewModel.onShouldShowWishlistSwipeTooltip = { [weak self] in
      DispatchQueue.main.async {
        self?.showSwipeTooltip()
      }
    }
    
    viewModel.onError = { [weak self] message in
      DispatchQueue.main.async { [weak self] in
        self?.presentAlert(title: "불러오기 실패", message: message)
      }
    }
    
    addWishButton.addTarget(self, action: #selector(didAddWish), for: .touchUpInside)
  }
}

// MARK: - TextField Delegate
extension WishlistViewController: UITableViewDataSource {
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
      withIdentifier: WishTicketTableViewCell.identifier,
      for: indexPath
    ) as? WishTicketTableViewCell else {
      return UITableViewCell()
    }
    
    let journey = viewModel.journeys[indexPath.row]
    
    cell.configure(
      bookItem: journey.book,
      departure: journey.departureAirport,
      destination: journey.arrivalAirport,
      registerDate: journey.createdAt,
      reason: journey.reason ?? ""
    )
    
    cell.onCheckInTriggered = { [weak self] in
      self?.onRoute?(.checkIn(journey))
    }
    
    cell.onLongPressTriggered = { [weak self] in
      guard let self else { return }
      
      let alert = UIAlertController(
        title: "삭제",
        message: "이 예약을 삭제할까요?",
        preferredStyle: .alert
      )
      
      alert.addAction(UIAlertAction(title: "취소", style: .cancel))
      
      alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
        Task { [weak self] in
          await self?.viewModel.deleteWishlistJourney(journeyId: journey.id)
        }
      })
      
      self.present(alert, animated: true)
    }
    
    return cell
  }
}

extension WishlistViewController: UITableViewDelegate {
  public func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 260
  }
}

// MARK: - Private
private extension WishlistViewController {
  @objc func didAddWish() {
    onRoute?(.addWish)
  }
  
  func setContentHidden(_ isHidden: Bool) {
    dividerView.isHidden = isHidden
    tableView.isHidden = isHidden
  }
  
  func setEmptyState(_ isEmpty: Bool) {
    emptyView.isHidden = !isEmpty
    dividerView.isHidden = isEmpty
    tableView.isHidden = isEmpty
    
    if isEmpty {
      swipeTooltipView.isHidden = true
    }
  }
  
  func showSwipeTooltip() {
    swipeTooltipView.isHidden = false
    swipeTooltipView.onTapClose = { [weak self] in
      self?.swipeTooltipView.dismiss()
    }
    
    // 외부 탭 시 닫기
    let outsideTap = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideTooltip))
    outsideTap.cancelsTouchesInView = false
    view.addGestureRecognizer(outsideTap)
  }
  
  @objc func didTapOutsideTooltip(_ gesture: UITapGestureRecognizer) {
    let location = gesture.location(in: view)
    guard !swipeTooltipView.frame.contains(location) else { return }
    swipeTooltipView.dismiss { [weak self] in
      self?.view.gestureRecognizers?.removeAll()
    }
  }
}
