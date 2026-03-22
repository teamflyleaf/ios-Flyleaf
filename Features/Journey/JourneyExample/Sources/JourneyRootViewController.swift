//
//  JourneyRootViewController.swift
//  Journey
//
//  Created by 여성일 on 3/21/26.
//

import UIKit
import SnapKit
import Then
import Core
import DesignSystem
import JourneyInterface
import JourneyFeature

final class JourneyRootViewController: BaseViewController {
  private let journeyBuilder: JourneyBuildable = JourneyBuilder()
  private let registerJourneyBuilder: RegisterJourneyBuildable = RegisterJourneyBuilder()
  private let journeyTicketBuilder: JourneyTicketBuildable = JourneyTicketBuilder()

  // MARK: - UI
  private let titleLabel = UILabel().then {
    $0.text = "Journey Example"
    $0.font = .boldSystemFont(ofSize: 28)
    $0.textAlignment = .center
    $0.textColor = .n0
  }

  private let journeyButton = UIButton(type: .system).then {
    $0.setTitle("Journey 화면", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
  }

  private let registerJourneyButton = UIButton(type: .system).then {
    $0.setTitle("RegisterJourney 화면", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
  }

  private let journeyTicketButton = UIButton(type: .system).then {
    $0.setTitle("JourneyTicket 화면", for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
  }

  private let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.alignment = .fill
    $0.distribution = .fillEqually
  }

  public override func configureUI() {
    title = "Journey"

    [
      titleLabel,
      stackView
    ].forEach {
      view.addSubview($0)
    }

    [
      journeyButton,
      registerJourneyButton,
      journeyTicketButton
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
      journeyButton,
      registerJourneyButton,
      journeyTicketButton
    ].forEach {
      $0.snp.makeConstraints {
        $0.height.equalTo(52)
      }
    }
  }

  public override func bind() {
    journeyButton.addTarget(self, action: #selector(didTapJourney), for: .touchUpInside)
    registerJourneyButton.addTarget(self, action: #selector(didTapRegisterJourney), for: .touchUpInside)
    journeyTicketButton.addTarget(self, action: #selector(didTapJourneyTicket), for: .touchUpInside)
  }
}

// MARK: - Private
private extension JourneyRootViewController {
  @objc func didTapJourney() {
    let viewController = journeyBuilder.build()
    navigationController?.pushViewController(viewController, animated: true)
  }

  @objc func didTapRegisterJourney() {
    let viewController = registerJourneyBuilder.build(
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
      onTapCreateTicket: { [weak self] book, departure, destination, startDate, currentPage in
        guard let self else { return }

        let payload = JourneyPayload(
          book: book,
          startDate: startDate,
          currentPage: currentPage,
          departureAirport: departure,
          destinationAirport: destination
        )

        let ticketViewController = self.journeyTicketBuilder.build(
          payload: payload,
          onTapBack: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
          },
          onUploadCompleted: {
            print("Journey ticket upload completed")
          }
        )

        self.navigationController?.pushViewController(ticketViewController, animated: true)
      }
    )

    navigationController?.pushViewController(viewController, animated: true)
  }

  @objc func didTapJourneyTicket() {
    let payload = JourneyPayload(
      book: makeBookInfo(),
      startDate: Date(),
      currentPage: 12,
      departureAirport: makeDepartureAirport(),
      destinationAirport: makeDestinationAirport()
    )

    let viewController = journeyTicketBuilder.build(
      payload: payload,
      onTapBack: { [weak self] in
        self?.navigationController?.popViewController(animated: true)
      },
      onUploadCompleted: {
        print("Journey ticket upload completed")
      }
    )

    navigationController?.pushViewController(viewController, animated: true)
  }
}

// MARK: - Helper
private extension JourneyRootViewController {
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
