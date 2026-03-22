//
//  JourneyViewController.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import Core
import DesignSystem
import SnapKit
import Then
import UIKit

public final class JourneyViewController: BaseViewController {
  // 현재 선택된 여행 인덱스
  private var selectedIndex: Int = 0
  // 현재 선택된 탭(세그먼트 버튼)
  private var selectedSegmentIndex: Int = 0
  // 첫 로딩 여부
  private var isInitialLoading = true
  
  private let viewModel: JourneyViewModel
  
  public init(viewModel: JourneyViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    Task { [weak self] in
      await self?.viewModel.loadReadingJourneys()
    }
  }
  
  // MARK: - UI
  private let headerTitleLabel = UILabel().then {
    $0.text = "여행"
    $0.font = .h2
    $0.textColor = .n0
  }
  
  private lazy var journeyCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).then {
    let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout
    layout?.scrollDirection = .horizontal
    layout?.minimumLineSpacing = 16
    layout?.minimumInteritemSpacing = 0
    
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
    $0.dataSource = self
    $0.delegate = self
    $0.register(
      JourneyProgressButtonCell.self,
      forCellWithReuseIdentifier: JourneyProgressButtonCell.identifier
    )
  }
  
  private let dividerView = DividerView()
  
  private let bookButton = NeutralSegmentChipButton()
  private let airplaneButton = NeutralSegmentChipButton()
  private let memoButton = NeutralSegmentChipButton()
  
  private let segmentScrollView = UIScrollView().then {
    $0.showsHorizontalScrollIndicator = false
    $0.alwaysBounceHorizontal = false
    $0.alwaysBounceVertical = false
    $0.contentInsetAdjustmentBehavior = .never
  }
  
  private let segmentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 8
    $0.alignment = .center
    $0.distribution = .fill
  }
  
  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
  }
  
  private let contentView = UIView()
  private let contentContainerView = UIView()
  
  private let bookInfoView = BookInfoView()
  private let journeyInfoView = JourneyInfoView()
  private let memoView = MemoView()
  
  private let initialLoadingIndicatorView = UIActivityIndicatorView(style: .large).then {
    $0.color = .n0
    $0.hidesWhenStopped = true
  }
  
  public override func configureUI() {
    [
      headerTitleLabel,
      journeyCollectionView,
      dividerView,
      segmentScrollView,
      scrollView,
      initialLoadingIndicatorView,
    ].forEach {
      view.addSubview($0)
    }
    
    segmentScrollView.addSubview(segmentStackView)
    
    scrollView.addSubview(contentView)
    contentView.addSubview(contentContainerView)
    
    [
      bookButton,
      airplaneButton,
      memoButton
    ].forEach {
      segmentStackView.addArrangedSubview($0)
    }
    
    bookButton.configure(icon: .book, title: "책정보", state: .selected)
    airplaneButton.configure(icon: .takeOff, title: "여행", state: .normal)
    memoButton.configure(icon: .pen, title: "메모", state: .normal)
    
    setContentHidden(true)
    initialLoadingIndicatorView.startAnimating()
  }
  
  public override func setupLayout() {
    headerTitleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    journeyCollectionView.snp.makeConstraints {
      $0.top.equalTo(headerTitleLabel.snp.bottom).offset(27)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(96)
    }
    
    dividerView.snp.makeConstraints {
      $0.top.equalTo(journeyCollectionView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
    }
    
    segmentScrollView.snp.makeConstraints {
      $0.top.equalTo(dividerView.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(36)
    }
    
    segmentStackView.snp.makeConstraints {
      $0.edges.equalTo(segmentScrollView.contentLayoutGuide).inset(
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
      )
      $0.height.equalTo(segmentScrollView.frameLayoutGuide)
    }
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(segmentScrollView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalTo(scrollView.contentLayoutGuide)
      $0.width.equalTo(scrollView.frameLayoutGuide)
    }
    
    contentContainerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    initialLoadingIndicatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  public override func bind() {
    bindSegmentButton()
    bindJourneyInfoView()
    bindMemoView()
    
    // 로딩상태 처리
    viewModel.onLoadingChanged = { [weak self] isLoading in
      DispatchQueue.main.async {
        guard let self else { return }
        
        if self.isInitialLoading {
          self.setContentHidden(isLoading)
          
          if isLoading {
            self.initialLoadingIndicatorView.startAnimating()
          } else {
            self.initialLoadingIndicatorView.stopAnimating()
            self.isInitialLoading = false
          }
        }
      }
    }
    
    viewModel.onJourneysChanged = { [weak self] journeys in
      DispatchQueue.main.async {
        guard let self else { return }
        
        if self.selectedIndex >= journeys.count {
          self.selectedIndex = 0
        }
        
        self.journeyCollectionView.reloadData()
        self.updateSelectedJourneyContent()
      }
    }
    
    viewModel.onError = { [weak self] message in
      DispatchQueue.main.async {
        self?.presentAlert(title: "불러오기 실패", message: message)
      }
    }
    
    viewModel.onMemosChanged = { [weak self] memos in
      DispatchQueue.main.async {
        self?.memoView.configure(memos)
      }
    }
    
    setupInitialContent()
  }
}

// MARK: - CollectionView Delegate
extension JourneyViewController: UICollectionViewDataSource {
  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    viewModel.numberOfItems
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: JourneyProgressButtonCell.identifier,
      for: indexPath
    ) as? JourneyProgressButtonCell else {
      return UICollectionViewCell()
    }
    
    let journey = viewModel.journeys[indexPath.item]
    
    cell.configure(
      airport: journey.arrivalAirport,
      book: journey.book,
      currentPage: journey.currentPage ?? 0
    )
    
    let isSelected = indexPath.item == selectedIndex
    cell.setSelected(isSelected)
    
    return cell
  }
}

extension JourneyViewController: UICollectionViewDelegate {
  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    selectedIndex = indexPath.item
    collectionView.reloadData()
    updateSelectedJourneyContent()
    
    if selectedSegmentIndex == 2 {
      let selectedJourney = viewModel.journeys[indexPath.item]
      Task { [weak self] in
        await self?.viewModel.loadMemos(journeyId: selectedJourney.id)
      }
    }
  }
}

extension JourneyViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    CGSize(width: 72, height: 96)
  }
}

// MARK: - Private
private extension JourneyViewController {
  // 세그먼트 탭 초기 상태 설정
  func setupInitialContent() {
    updateSegmentSelection(index: 0)
  }
  
  func setContentHidden(_ isHidden: Bool) {
    headerTitleLabel.isHidden = isHidden
    journeyCollectionView.isHidden = isHidden
    dividerView.isHidden = isHidden
    segmentScrollView.isHidden = isHidden
    scrollView.isHidden = isHidden
  }
  
  // 세그먼트 버튼 클릭 시 업데이트
  func updateSegmentSelection(index: Int) {
    selectedSegmentIndex = index
    
    let buttons = [
      bookButton,
      airplaneButton,
      memoButton
    ]
    
    for (buttonIndex, button) in buttons.enumerated() {
      let state: NeutralSegmentChipButton.State = buttonIndex == index ? .selected : .normal
      button.updateState(state)
    }
    
    switch index {
    case 0:
      showContentView(bookInfoView)
    case 1:
      showContentView(journeyInfoView)
    case 2:
      showContentView(memoView)
      guard viewModel.journeys.indices.contains(selectedIndex) else { return }
      let selectedJourney = viewModel.journeys[selectedIndex]
      
      Task { [weak self] in
        await self?.viewModel.loadMemos(journeyId: selectedJourney.id)
      }
    default:
      showContentView(bookInfoView)
    }
    
    updateSelectedJourneyContent()
  }
  
  // 현재 선택된 여행 데이터를 화면에 바인딩하기 위한 메서드
  func updateSelectedJourneyContent() {
    guard viewModel.journeys.indices.contains(selectedIndex) else { return }
    
    let selectedJourney = viewModel.journeys[selectedIndex]
    bookInfoView.configure(selectedJourney.book)
    journeyInfoView.configure(selectedJourney)
  }
  
  // 세그먼트 버튼 클릭 시 선택된 탭에 맞는 뷰를 보여주기 위한 메서드
  func showContentView(_ targetView: UIView) {
    contentContainerView.subviews.forEach { $0.removeFromSuperview() }
    
    contentContainerView.addSubview(targetView)
    
    targetView.snp.remakeConstraints {
      $0.edges.equalToSuperview().inset(20)
    }
    
    if targetView === memoView {
      targetView.snp.makeConstraints {
        $0.height.equalTo(scrollView.frameLayoutGuide).offset(-40)
      }
    }
  }
  
  func updateCurrentPage(_ page: Int) {
    guard viewModel.journeys.indices.contains(selectedIndex) else { return }
    
    let selectedJourney = viewModel.journeys[selectedIndex]
    
    Task { [weak self] in
      await self?.viewModel.updateCurrentPage(
        journeyId: selectedJourney.id,
        currentPage: page
      )
    }
  }
  
  func bindSegmentButton() {
    bookButton.onTap = { [weak self] in
      self?.updateSegmentSelection(index: 0)
    }
    
    airplaneButton.onTap = { [weak self] in
      self?.updateSegmentSelection(index: 1)
    }
    
    memoButton.onTap = { [weak self] in
      self?.updateSegmentSelection(index: 2)
    }
  }
  
  func bindJourneyInfoView() {
    journeyInfoView.onPageChanged = { [weak self] page in
      self?.updateCurrentPage(page)
    }
  }
  
  func bindMemoView() {
    memoView.onTapAddMemo = { [weak self] in
      self?.presentMemoWriteSheet()
    }
    
    memoView.onTapMemo = { [weak self] memo in
      self?.presentMemoEditSheet(memo)
    }
    
    memoView.onLongPressMemo = { [weak self] memo in
      self?.presentDeleteMemoAlert(memo)
    }
  }
}

// MARK: - Alert, Sheet
private extension JourneyViewController {
  // 메모 작성 시트 show
  func presentMemoWriteSheet() {
    guard viewModel.journeys.indices.contains(selectedIndex) else { return }
    
    let selectedJourney = viewModel.journeys[selectedIndex]
    let vc = MemoWriteViewController(book: selectedJourney.book)
    
    vc.onTapSave = { [weak self] memo in
      Task {
        await self?.viewModel.saveMemo(
          journeyId: selectedJourney.id,
          memo: memo
        )
      }
    }
    
    if let sheet = vc.sheetPresentationController {
      sheet.detents = [
        .custom { _ in 550 }
      ]
      sheet.preferredCornerRadius = 24
    }
    
    present(vc, animated: true)
  }
  
  // 메모 편집 시트 show
  func presentMemoEditSheet(_ memo: JourneyMemo) {
    guard viewModel.journeys.indices.contains(selectedIndex) else { return }
    
    let selectedJourney = viewModel.journeys[selectedIndex]
    let vc = MemoWriteViewController(
      book: selectedJourney.book,
      existingMemo: memo
    )
    
    vc.onTapSave = { [weak self] updatedMemo in
      Task {
        await self?.viewModel.updateMemo(
          journeyId: selectedJourney.id,
          memo: updatedMemo
        )
      }
    }
    
    if let sheet = vc.sheetPresentationController {
      sheet.detents = [
        .custom { _ in 550 }
      ]
      sheet.preferredCornerRadius = 24
    }
    
    present(vc, animated: true)
  }
  
  // 메모 삭제 알럿 show
  func presentDeleteMemoAlert(_ memo: JourneyMemo) {
    let alert = UIAlertController(
      title: "메모 삭제",
      message: "이 메모를 삭제할까요?",
      preferredStyle: .actionSheet
    )
    
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
      guard let self else { return }
      guard self.viewModel.journeys.indices.contains(self.selectedIndex) else { return }
      
      let selectedJourney = self.viewModel.journeys[self.selectedIndex]
      
      Task {
        await self.viewModel.deleteMemo(
          journeyId: selectedJourney.id,
          memoId: memo.id
        )
      }
    }
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    
    if let popover = alert.popoverPresentationController {
      popover.sourceView = view
      popover.sourceRect = CGRect(
        x: view.bounds.midX,
        y: view.bounds.midY,
        width: 1,
        height: 1
      )
    }
    
    present(alert, animated: true)
  }
}
