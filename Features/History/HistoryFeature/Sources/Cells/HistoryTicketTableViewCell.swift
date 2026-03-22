//
//  HistoryTicketTableViewCell.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import Core
import DesignSystem
import UIKit

final class HistoryTicketTableViewCell: UITableViewCell {
  static let identifier = "HistoryTicketTableViewCell"
  
  var onLongPressTriggered: (() -> Void)?
  
  private var longPressGesture: UILongPressGestureRecognizer?
  
  // MARK: - UI
  private let containerView = UIView()
  private let ticketView = HistoryTicketView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
    setupLayout()
    setupGesture()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.frame = contentView.frame.inset(
      by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    )
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    containerView.transform = .identity
  }
  
  private func configureUI() {
    selectionStyle = .none
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    contentView.addSubview(containerView)
    containerView.addSubview(ticketView)
  }
  
  private func setupLayout() {
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    ticketView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  private func setupGesture() {
    let longPress = UILongPressGestureRecognizer(
      target: self,
      action: #selector(handleLongPress)
    )
    longPress.minimumPressDuration = 0.5
    containerView.addGestureRecognizer(longPress)
    longPressGesture = longPress
  }
  
  // MARK: - Public
  func configure(
    bookItem: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    finishDate: Date
  ) {
    ticketView.configure(
      bookItem: bookItem,
      departure: departure,
      destination: destination,
      finishDate: finishDate
    )
  }
}

// MARK: - Gesture
private extension HistoryTicketTableViewCell {
  @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    if gesture.state == .began {
      onLongPressTriggered?()
    }
  }
}
