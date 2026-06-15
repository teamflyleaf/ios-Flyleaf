//
//  OnboardingPage4ViewController.swift
//  Onboarding
//
//  Created by 여성일 on 6/15/26.
//

import Core
import UIKit
import DesignSystem
import SnapKit
import Then

public class OnboardingPage4ViewController: BaseViewController {
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.text = "독서 여정 기록을 모아보세요"
    $0.font = .h2
    $0.textColor = .n0
    $0.textAlignment = .left
  }
  
  private let subtitleLabel = UILabel().then {
    $0.text = "읽은 책들은 항공편처럼 쌓이고,\n당신만의 독서 지도가 완성됩니다"
    $0.font = .c1
    $0.textColor = .n20
    $0.textAlignment = .left
    $0.numberOfLines = 0
  }
  
  private let historyTicketView1 = HistoryTicketView().then {
    $0.isHidden = true
    $0.alpha = 0
  }
  
  private let historyTicketView2 = HistoryTicketView().then {
    $0.isHidden = true
    $0.alpha = 0
  }
   
  private let historyTicketView3 = HistoryTicketView().then {
    $0.isHidden = true
    $0.alpha = 0
  }
  
  private let startButton = CTAButton(title: "시작하기").then {
    $0.isHidden = true
    $0.alpha = 0
  }
  
  // MARK: - LifeCycle
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    Task { await startAnimation() }
  }
  
  // MARK: - Configure
  override public func configureUI() {
    view.backgroundColor = .bg0
    
    [
      titleLabel,
      subtitleLabel,
      historyTicketView1,
      historyTicketView2,
      historyTicketView3,
      startButton
    ].forEach {
      view.addSubview($0)
    }
    
    let ticket1 = Self.makeMockTicket(0)
    historyTicketView1.configure(bookItem: ticket1.0, departure: ticket1.1, destination: ticket1.2, finishDate: ticket1.3)
    historyTicketView1.transform = CGAffineTransform(rotationAngle: -.pi / 14)

    let ticket2 = Self.makeMockTicket(1)
    historyTicketView2.configure(bookItem: ticket2.0, departure: ticket2.1, destination: ticket2.2, finishDate: ticket2.3)
    historyTicketView2.transform = CGAffineTransform(rotationAngle: .pi / 18)

    let ticket3 = Self.makeMockTicket(2)
    historyTicketView3.configure(bookItem: ticket3.0, departure: ticket3.1, destination: ticket3.2, finishDate: ticket3.3)
    historyTicketView3.transform = CGAffineTransform(rotationAngle: -.pi / 22)
  }
  
  override public func setupLayout() {
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    subtitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    historyTicketView1.snp.makeConstraints {
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(70)
      $0.leading.equalToSuperview().offset(-62)
    }
    
    historyTicketView2.snp.makeConstraints {
      $0.top.equalTo(historyTicketView1.snp.top).offset(60)
      $0.trailing.equalToSuperview().offset(26)
    }
    
    historyTicketView3.snp.makeConstraints {
      $0.top.equalTo(historyTicketView2.snp.top).offset(100)
      $0.leading.equalToSuperview().offset(16)
    }
    
    startButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(52)
    }
  }
}

// MARK: - Private
private extension OnboardingPage4ViewController {
  static func makeDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    return Calendar.current.date(from: components) ?? Date()
  }
  
  static func makeMockTicket(_ index: Int) -> (BookInfo, AirportInfo, AirportInfo, Date) {
    switch index {
    case 0:
      return (
        BookInfo(isbn13: "", title: "설국", author: "가와타바 야스나리", publisher: "", itemPage: 235, cover: "", description: ""),
        AirportInfo(iata: "CJJ", airportNameEn: "Cheongju International Airport", airportNameKo: "청주국제공항", cityNameEn: "Cheongju", cityNameKo: "청주", countryNameKo: "대한민국", latitude: 36.71556, longitude: 127.500289, searchText: ""),
        AirportInfo(iata: "FUK", airportNameEn: "Fukuoka Airport", airportNameKo: "후쿠오카 공항", cityNameEn: "Fukuoka", cityNameKo: "후쿠오카", countryNameKo: "일본", latitude: 33.585899353027344, longitude: 130.4510040283203, searchText: ""),
        makeDate(2023, 1, 13)
      )
    case 1:
      return (
        BookInfo(isbn13: "", title: "동물농장", author: "조지 오웰", publisher: "", itemPage: 315, cover: "", description: ""),
        AirportInfo(iata: "ICN", airportNameEn: "Seoul Incheon International Airport", airportNameKo: "인천국제공항", cityNameEn: "Seoul", cityNameKo: "서울", countryNameKo: "대한민국", latitude: 37.469101, longitude: 126.450996, searchText: ""),
        AirportInfo(iata: "LPL", airportNameEn: "Liverpool John Lennon Airport", airportNameKo: "리버풀 존 레논 공항", cityNameEn: "Liverpool", cityNameKo: "리버풀", countryNameKo: "영국", latitude: 53.334863, longitude: -2.849637, searchText: ""),
        makeDate(2025, 11, 8)
      )
    case 2:
      return (
        BookInfo(isbn13: "", title: "멋진 개발자가 될거야", author: "여성일", publisher: "", itemPage: 310, cover: "", description: ""),
        AirportInfo(iata: "CJJ", airportNameEn: "Cheongju International Airport", airportNameKo: "청주국제공항", cityNameEn: "Cheongju", cityNameKo: "청주", countryNameKo: "대한민국", latitude: 36.71556, longitude: 127.500289, searchText: ""),
        AirportInfo(iata: "LPL", airportNameEn: "Liverpool John Lennon Airport", airportNameKo: "리버풀 존 레논 공항", cityNameEn: "Liverpool", cityNameKo: "리버풀", countryNameKo: "영국", latitude: 53.334863, longitude: -2.849637, searchText: ""),
        makeDate(1999, 3, 10)
      )
    default: fatalError()
    }
  }
  
  func startAnimation() async {
    showTicket(historyTicketView1)
    try? await Task.sleep(for: .seconds(0.7))
    showTicket(historyTicketView2)
    try? await Task.sleep(for: .seconds(0.7))
    showTicket(historyTicketView3)
    try? await Task.sleep(for: .seconds(0.7))
    showStartButton()
  }
  
  func showTicket(_ view: HistoryTicketView) {
    view.alpha = 0
    UIView.animate(withDuration: 0.5) {
      view.isHidden = false
      view.alpha = 1
    }
  }
  
  func showStartButton() {
    UIView.animate(withDuration: 0.5) {
      self.startButton.isHidden = false
      self.startButton.alpha = 1
    }
  }
}
