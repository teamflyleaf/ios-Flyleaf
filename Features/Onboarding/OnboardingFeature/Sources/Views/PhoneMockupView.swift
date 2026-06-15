//
//  PhoneMockupView.swift
//  Onboarding
//
//  Created by 여성일 on 6/10/26.
//

import DesignSystem
import SnapKit
import Then
import UIKit

public class PhoneMockupView: BaseView {
  public var onScrollCompleted: (() -> Void)?
  
  // MARK: - UI
  private let scrollView = UIScrollView().then {
    $0.isPagingEnabled = true
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
    $0.bounces = false
    $0.isScrollEnabled = false
  }

  private let contentView = UIView()

  private let page1ImageView = UIImageView().then {
    $0.image = .searchAirportPage1
    $0.contentMode = .scaleAspectFit
  }

  private let page2ImageView = UIImageView().then {
    $0.image = .searchAirportPage2
    $0.contentMode = .scaleAspectFit
  }

  private let page3ImageView = UIImageView().then {
    $0.image = .searchAirportPage3
    $0.contentMode = .scaleAspectFit
  }

  private var currentPage = 0
  private var autoScrollTimer: Timer?

  // MARK: - Configure
  override public func configureUI() {
    backgroundColor = .clear
    clipsToBounds = true
    layer.cornerRadius = 48
    layer.borderWidth = 5
    layer.borderColor = UIColor.n40.cgColor

    [page1ImageView, page2ImageView, page3ImageView].forEach {
      contentView.addSubview($0)
    }
    scrollView.addSubview(contentView)
    addSubview(scrollView)
  }

  override public func setupLayout() {
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override public func layoutSubviews() {
    super.layoutSubviews()

    let pageWidth  = bounds.width
    let pageHeight = bounds.height

    contentView.frame = CGRect(x: 0, y: 0, width: pageWidth * 3, height: pageHeight)
    page1ImageView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    page2ImageView.frame = CGRect(x: pageWidth, y: 0, width: pageWidth, height: pageHeight)
    page3ImageView.frame = CGRect(x: pageWidth * 2, y: 0, width: pageWidth, height: pageHeight)
  }

  // MARK: - Auto Scroll
  public func startAutoScroll() {
    autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.scrollToNextPage()
    }
  }

  public func stopAutoScroll() {
    autoScrollTimer?.invalidate()
    autoScrollTimer = nil
  }

  deinit {
    autoScrollTimer?.invalidate()
  }
}

// MARK: - Private
private extension PhoneMockupView {
  func scrollToNextPage() {
    currentPage = (currentPage + 1) % 3
    let offset = CGPoint(x: bounds.width * CGFloat(currentPage), y: 0)
    scrollView.setContentOffset(offset, animated: true)
    
    if currentPage == 0 {
      onScrollCompleted?()
    }
  }
}
