//
//  WishlistTicketViewController.swift
//  Wishlist
//
//  Created by 여성일 on 3/16/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

public final class WishTicketViewController: BaseViewController {
  public var onTapBack: (() -> Void)?
  public var onUploadCompleted: (() -> Void)?
  
  private let viewModel: WishTicketViewModel
  
  // 중복 실행 방지를 위한 변수
  private var hasStartedAnimation = false
  
  public init(viewModel: WishTicketViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // 애니메이션 중복 실행 방지 (viewDidAppear 재호출 시 방지)
    guard !hasStartedAnimation else { return }
    hasStartedAnimation = true
    
    printerView.startPrintAnimation()
  }
  
  // MARK: - UI
  private let headerView = HeaderView(title: "탑승권 발급")
  private let dividerView = DividerView()
  
  private let printerView = TicketPrinterView()
  private let button = CTAButton(title: "완료").then {
    $0.isEnabled = false
  }
  
  override public func configureUI() {
    [
      headerView,
      dividerView,
      printerView,
      button
    ].forEach {
      view.addSubview($0)
    }
    
    button.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
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
    
    printerView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(22)
      $0.horizontalEdges.equalToSuperview().inset(30)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(button.snp.top).offset(-40)
    }
    
    button.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
  }
  
  override public func bind() {
    headerView.onTapBack = { [weak self] in
      self?.onTapBack?()
    }
    
    printerView.configure(
      bookItem: viewModel.payload.book,
      departure: viewModel.payload.departure,
      destination: viewModel.payload.destination
    )
    
    printerView.onPrintAnimationCompleted = { [weak self] in
      self?.button.isEnabled = true
    }
    
    viewModel.onUploadStateChanged = { [weak self] isLoading in
      DispatchQueue.main.async {
        self?.button.isEnabled = !isLoading
      }
    }
    
    viewModel.onUploadSuccess = { [weak self] _ in
      DispatchQueue.main.async {
        self?.onUploadCompleted?()
      }
    }
    
    viewModel.onError = { [weak self] message in
      DispatchQueue.main.async {
        self?.presentAlert(title: "저장 실패", message: message)
      }
    }
  }
}

// MARK: - Private
private extension WishTicketViewController {
  @objc func didTapComplete() {
    Task { [weak self] in
      await self?.viewModel.uploadReadingJourney()
    }
  }
}
