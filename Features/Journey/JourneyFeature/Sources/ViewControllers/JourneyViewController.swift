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
import JourneyInterface

public final class JourneyViewController: BaseViewController {
  public var onRoute: ((JourneyRoute) -> Void)?
  
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
  
  private let addJourneyButton = UIButton().then {
    $0.setImage(.plus, for: .normal)
    $0.tintColor = .n0
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
  
  private let deleteJourneyButton = UIButton().then {
    $0.setImage(.trash, for: .normal)
    $0.tintColor = .n0
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
  
  private let emptyView = UIView().then {
    $0.isHidden = true
  }
  
  private let emptyTitleLabel = UILabel().then {
    $0.text = "진행 중인 여행이 없어요"
    $0.font = .b1_sb
    $0.textColor = .n0
    $0.textAlignment = .center
  }
  
  private let emptyDescriptionLabel = UILabel().then {
    $0.text = "새로운 독서 여행을 시작해보세요"
    $0.font = .c3
    $0.textColor = .n20
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  public override func configureUI() {
    [
      headerTitleLabel,
      addJourneyButton,
      journeyCollectionView,
      dividerView,
      segmentScrollView,
      deleteJourneyButton,
      scrollView,
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
    
    addJourneyButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.trailing.equalToSuperview().inset(20)
      $0.width.height.equalTo(24)
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
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(deleteJourneyButton.snp.leading).offset(-20)
      $0.height.equalTo(36)
    }

    deleteJourneyButton.snp.makeConstraints {
      $0.centerY.equalTo(segmentScrollView)
      $0.trailing.equalToSuperview().inset(20)
      $0.width.height.equalTo(24)
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
    bindSegmentButton()
    bindJourneyInfoView()
    bindMemoView()
    
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
          self.selectedIndex = 0
          self.journeyCollectionView.reloadData()
          self.clearSelectedJourneyContent()
          self.setEmptyState(true)
          return
        }
        
        self.setEmptyState(false)
        
        if self.selectedIndex >= journeys.count {
          self.selectedIndex = max(0, journeys.count - 1)
        }
        
        // 첫 데이터 진입 시에만 기본 탭 세팅
        if self.contentContainerView.subviews.isEmpty {
          self.updateSegmentSelection(index: self.selectedSegmentIndex)
        }
        
        self.journeyCollectionView.reloadData()
        self.updateSelectedJourneyContent()
        
        if self.selectedSegmentIndex == 2 {
          let selectedJourney = journeys[self.selectedIndex]
          Task { [weak self] in
            await self?.viewModel.loadMemos(journeyId: selectedJourney.id)
          }
        }
      }
    }
    
    viewModel.onError = { [weak self] message in
      DispatchQueue.main.async { [weak self] in
        self?.presentAlert(title: "불러오기 실패", message: message)
      }
    }
    
    viewModel.onMemosChanged = { [weak self] memos in
      DispatchQueue.main.async { [weak self] in
        self?.memoView.configure(memos)
      }
    }
    
    addJourneyButton.addTarget(self, action: #selector(didAddJourney), for: .touchUpInside)
    deleteJourneyButton.addTarget(self, action: #selector(didDeleteJourney), for: .touchUpInside)
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
    
    cell.onLongPressTriggered = { [weak self] in
      self?.presentDeleteAlert(message: "이 여행을 삭제할까요?") { [weak self] in
        Task {
          await self?.viewModel.deleteJourney(journeyId: journey.id)
        }
      }
    }
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
  @objc func didAddJourney() {
    onRoute?(.addJourney)
  }
  
  @objc func didDeleteJourney() {
    guard viewModel.journeys.indices.contains(selectedIndex) else { return }
    let journey = viewModel.journeys[selectedIndex]
    
    presentDeleteAlert(message: "이 여행을 삭제할까요?") { [weak self] in
      Task {
        await self?.viewModel.deleteJourney(journeyId: journey.id)
      }
    }
  }
  
  // 컨텐츠 숨김 처리
  func setContentHidden(_ isHidden: Bool) {
    journeyCollectionView.isHidden = isHidden
    dividerView.isHidden = isHidden
    segmentScrollView.isHidden = isHidden
    scrollView.isHidden = isHidden
    deleteJourneyButton.isHidden = isHidden
  }
  
  // Empty 상태 처리
  func setEmptyState(_ isEmpty: Bool) {
    emptyView.isHidden = !isEmpty
    
    journeyCollectionView.isHidden = isEmpty
    dividerView.isHidden = isEmpty
    segmentScrollView.isHidden = isEmpty
    scrollView.isHidden = isEmpty
    deleteJourneyButton.isHidden = isEmpty
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
      viewModel.checkCurrentPageTooltip()
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
  
  // 현재 표시 중인 컨텐츠 뷰 초기화
  // 데이터가 없는 상태로 전환될 때 이전 여행 정보 UI가 남아있지 않도록 제거하기 위함임
  func clearSelectedJourneyContent() {
    contentContainerView.subviews.forEach { $0.removeFromSuperview() }
  }
  
  // 사용자가 읽은 페이지 수를 변경했을 때 호출하여 업데이트
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
    
    journeyInfoView.onTapFinish = { [weak self] in
      self?.presentJourneyFinishSheet()
    }
    
    viewModel.onShouldShowCurrentPageTooltip = { [weak self] in
      DispatchQueue.main.async {
        self?.journeyInfoView.showCurrentPageTooltip()
      }
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
  
  // 여행 마치기 시트 show
  func presentJourneyFinishSheet() {
    guard viewModel.journeys.indices.contains(selectedIndex) else { return }
    
    let selectedJourney = viewModel.journeys[selectedIndex]
    let vc = JourneyFinishViewController(existingReview: selectedJourney.review)
    
    vc.onTapComplete = { [weak self] review in
      Task {
        await self?.viewModel.finishJourney(
          journeyId: selectedJourney.id,
          review: review
        )
      }
    }
    
    if let sheet = vc.sheetPresentationController {
      sheet.detents = [
        .custom { _ in 460 }
      ]
      sheet.preferredCornerRadius = 24
    }
    
    present(vc, animated: true)
  }
}
