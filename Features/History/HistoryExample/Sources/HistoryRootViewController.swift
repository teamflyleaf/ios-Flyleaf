//
//  HistoryRootViewController.swift
//  History
//
//  Created by 여성일 on 3/22/26.
//

import UIKit
import SnapKit
import Then
import Core
import DesignSystem
import HistoryInterface
import HistoryFeature

final class HistoryRootViewController: BaseViewController {
  private let historyBuilder: HistoryBuildable = HistoryBuilder()
  private let registerHistoryBuilder: RegisterHistoryBuildable = RegisterHistoryBuilder()
  private let detailHistoryBuilder: DetailHistoryBuildable = DetailHistoryBuilder()
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.text = "History Example"
    $0.font = .boldSystemFont(ofSize: 28)
    $0.textAlignment = .center
    $0.textColor = .n0
  }
  
  private let historyButton = UIButton(type: .system).then {
    $0.setTitle("History 화면", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
  }
  
  private let registerHistoryButton = UIButton(type: .system).then {
    $0.setTitle("RegisterHistory 화면", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
  }
  
  private let detailHistoryButton = UIButton(type: .system).then {
    $0.setTitle("DetailHistory 화면", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }
  
  public override func configureUI() {
    title = "History"
    
    [
      titleLabel,
      stackView
    ].forEach {
      view.addSubview($0)
    }
    
    [
      historyButton,
      registerHistoryButton,
      detailHistoryButton
    ].forEach {
      stackView.addArrangedSubview($0)
    }
  }
  
  public override func setupLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    stackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(40)
      $0.horizontalEdges.equalToSuperview().inset(24)
    }
    
    [
      historyButton,
      registerHistoryButton,
      detailHistoryButton
    ].forEach {
      $0.snp.makeConstraints {
        $0.height.equalTo(52)
      }
    }
  }
  
  public override func bind() {
    historyButton.addTarget(self, action: #selector(didTapHistory), for: .touchUpInside)
    registerHistoryButton.addTarget(self, action: #selector(didTapRegisterHistory), for: .touchUpInside)
    detailHistoryButton.addTarget(self, action: #selector(didTapDetailHistory), for: .touchUpInside)
  }
}

// MARK: - Private
private extension HistoryRootViewController {
  @objc func didTapHistory() {
    let viewController = historyBuilder.build()
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  @objc func didTapRegisterHistory() {
    let viewController = registerHistoryBuilder.build(
      onTapBack: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      },
      onTapRegisterBookSearch: { completion in
        completion(self.makeBookInfo())
      },
      onTapSelectDepartureButton: { completion in
        completion(self.makeDepartureAirport())
      },
      onTapSelectDestinationButton: { completion in
        completion(self.makeDestinationAirport())
      },
      onUploadCompleted: {
        print("History upload completed")
      }
    )
    
    navigationController?.pushViewController(viewController, animated: true)
  }
  
  @objc func didTapDetailHistory() {
    let viewController = detailHistoryBuilder.build()
    navigationController?.pushViewController(viewController, animated: true)
  }
}

// MARK: - Helper
private extension HistoryRootViewController {
  func makeBookInfo() -> BookInfo {
    BookInfo(
      isbn13: "9788937460616",
      title: "테스트 도서",
      author: "테스트 작가",
      publisher: "테스트 출판사",
      itemPage: 320,
      cover: "https://example.com/cover.jpg",
      description: "test"
    )
  }
  
  func makeDepartureAirport() -> AirportInfo {
    AirportInfo(
      iata: "ICN",
      airportNameEn: "Incheon International Airport",
      airportNameKo: "인천국제공항",
      cityNameEn: "Seoul",
      cityNameKo: "서울",
      countryNameKo: "대한민국",
      latitude: 37.4602,
      longitude: 126.4407,
      searchText: "icn incheon seoul 인천 서울"
    )
  }
  
  func makeDestinationAirport() -> AirportInfo {
    AirportInfo(
      iata: "NRT",
      airportNameEn: "Narita International Airport",
      airportNameKo: "나리타국제공항",
      cityNameEn: "Tokyo",
      cityNameKo: "도쿄",
      countryNameKo: "일본",
      latitude: 35.7719,
      longitude: 140.3929,
      searchText: "nrt narita tokyo 나리타 도쿄"
    )
  }
}
