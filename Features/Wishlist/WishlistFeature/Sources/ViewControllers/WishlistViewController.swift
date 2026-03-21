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

public final class WishlistViewController: BaseViewController {
  public var onTapCheckIn: ((ReadingJourney) -> Void)?
  
  private let viewModel: WishlistViewModel
  
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
  private let dividerView = DividerView()
  
  private let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .clear
    $0.showsVerticalScrollIndicator = false
  }
  
  public override func configureUI() {
    [
      headerTitleLabel,
      dividerView,
      tableView
    ].forEach {
      view.addSubview($0)
    }

    tableView.register(WishTicketTableViewCell.self, forCellReuseIdentifier: WishTicketTableViewCell.identifier)
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  public override func setupLayout() {
    headerTitleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
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
  }
  
  public override func bind() {
    viewModel.onJourneysChanged = { [weak self] _ in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    
    viewModel.onError = { [weak self] message in
      DispatchQueue.main.async {
        self?.presentAlert(title: "불러오기 실패", message: message)
      }
    }
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
      self?.onTapCheckIn?(journey)
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
