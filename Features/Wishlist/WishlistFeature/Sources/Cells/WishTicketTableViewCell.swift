//
//  WishTicketTableViewCell.swift
//  Wishlist
//
//  Created by 여성일 on 3/20/26.
//

import Core
import DesignSystem
import UIKit

final class WishTicketTableViewCell: UITableViewCell {
  static let identifier = "WishTicketTableViewCell"
  
  var onCheckInTriggered: (() -> Void)?
  var onLongPressTriggered: (() -> Void)?
  
  private var panGesture: UIPanGestureRecognizer?
  private var longPressGesture: UILongPressGestureRecognizer?
  
  private let dragHapticGenerator = UIImpactFeedbackGenerator(style: .rigid)
  private let completeHapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
  
  private var lastHapticX: CGFloat = 0
  private let hapticStep: CGFloat = 12
  
  private let swipeTriggerThreshold: CGFloat = 120
  
  // MARK: - UI
  private let containerView = UIView()
  private let ticketView = WishTicketView()
  
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
    lastHapticX = 0
  }
  
  // 테이블뷰 스크롤이랑 스와이프 제스처 충돌 방지
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
      return true
    }
    
    let velocity = panGesture.velocity(in: contentView)
    return abs(velocity.x) > abs(velocity.y) && velocity.x > 0
  }
  
  // 테이블뷰 스크롤 스와이프랑, 티켓 스와이프 동시 인식 제한
  override func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    return false
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
    let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    containerView.addGestureRecognizer(pan)
    panGesture = pan
    pan.delegate = self

    let longPress = UILongPressGestureRecognizer(
      target: self,
      action: #selector(handleLongPress)
    )
    longPress.minimumPressDuration = 0.5
    containerView.addGestureRecognizer(longPress)
    longPressGesture = longPress
  }
  
  func configure(
    bookItem: BookInfo,
    departure: AirportInfo,
    destination: AirportInfo,
    registerDate: Date,
    reason: String
  ) {
    ticketView.configure(
      bookItem: bookItem,
      departure: departure,
      destination: destination,
      registerDate: registerDate,
      reason: reason
    )
  }
}

// MARK: - Gesture
private extension WishTicketTableViewCell {
  @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: contentView)
    let x = max(0, translation.x)
    
    switch gesture.state {
      
    case .began:
      lastHapticX = 0
      dragHapticGenerator.prepare()
      completeHapticGenerator.prepare()
      
    case .changed:
      containerView.transform = CGAffineTransform(translationX: x, y: 0)
      
      if x - lastHapticX >= hapticStep {
        lastHapticX = x
        dragHapticGenerator.impactOccurred(intensity: 0.7)
        dragHapticGenerator.prepare()
      }
      
    case .ended, .cancelled, .failed:
      let shouldTrigger = x >= swipeTriggerThreshold
      
      if shouldTrigger {
        completeHapticGenerator.impactOccurred(intensity: 1.0)
        onCheckInTriggered?()
      }
      
      UIView.animate(withDuration: 0.25) {
        self.containerView.transform = .identity
      }
      
    default:
      break
    }
  }
  
  @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    if gesture.state == .began {
      onLongPressTriggered?()
    }
  }
}
