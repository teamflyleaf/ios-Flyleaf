//
//  SceneDelegate.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/1/26.
//

import Core
import HomeFeature
import LoginFeature
import UIKit
import SearchFeature
import WishlistFeature
import HistoryFeature
import JourneyFeature
import SettingFeature

import AirportSearchInterface
import AuthInterface
import BookSearchInterface
import ReadingJourneyInterface
import SearchHistoryInterface
import TooltipInterface

import AirportSearchImplementation
import AuthImplementation
import BookSearchImplementation
import ReadingJourneyImplementation
import SearchHistoryImplementation
import TooltipImplementation

import DIContainer

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  var appCoordinator: AppCoordinator?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    
    guard let windowScene = scene as? UIWindowScene else { return }

    let navigationController = UINavigationController()
    navigationController.navigationBar.isHidden = true

    let container = DIContainer()

    // MARK: - Services
    // .singleton: Firestore 기반, 상태를 가짐. 앱 전체에서 동일 인스턴스가 데이터를 공유해야 함
    container.register(ReadingJourneyServicing.self, scope: .singleton) { ReadingJourneyService() }

    // .singleton: Firebase Auth 래퍼, isSignedIn 등 상태를 가짐
    container.register(AuthServicing.self, scope: .singleton) { AuthService() }

    // .transient: 순수 HTTP 클라이언트 (URLSession.shared 사용), 내부 상태 없음
    container.register(BookSearchServicing.self, scope: .transient) { BookSearchService() }

    // .singleton: Firestore 기반, 상태를 가짐
    container.register(JourneyMemoServicing.self, scope: .singleton) { JourneyMemoService() }

    // .singleton: UserDefaults 기반, 검색 기록 상태를 가짐
    container.register(SearchHistoryServicing.self, scope: .singleton) { SearchHistoryService() }

    // .singleton: UserDefaults 기반, 툴팁 표시 여부 상태를 가짐
    container.register(TooltipServicing.self, scope: .singleton) { TooltipService() }

    // .singleton: 앱 번들에서 JSON을 메모리에 로드하는 비용이 큼. 한 번만 생성해야 함
    container.register(AirportSearchServicing.self, scope: .singleton) {
      AirportSearchService(bundle: Bundle(for: AirportSearchService.self))
    }

    // MARK: - Builders
    // .transient: Builder는 ViewController를 만드는 순수 팩토리. 내부 상태 없음.
    // 단, 주입받는 Service는 위에서 .singleton으로 등록되어 있으므로
    // 매번 새 Builder가 만들어지더라도 동일한 Service 인스턴스를 받음

    container.register(HomeBuilder.self, scope: .transient) {
      HomeBuilder(
        readingJourneyService: container.resolve(ReadingJourneyServicing.self)!
      )
    }

    container.register(LoginBuilder.self, scope: .transient) {
      LoginBuilder(
        authService: container.resolve(AuthServicing.self)!
      )
    }

    container.register(SearchBuilder.self, scope: .transient) {
      SearchBuilder(
        airportSearchService: container.resolve(AirportSearchServicing.self)!,
        bookSearchService: container.resolve(BookSearchServicing.self)!,
        searchHistoryService: container.resolve(SearchHistoryServicing.self)!
      )
    }

    container.register(WishlistBuilder.self, scope: .transient) {
      WishlistBuilder(
        readingJourneyService: container.resolve(ReadingJourneyServicing.self)!,
        tooltipService: container.resolve(TooltipServicing.self)!
      )
    }

    container.register(HistoryBuilder.self, scope: .transient) {
      HistoryBuilder(
        readingJourneyService: container.resolve(ReadingJourneyServicing.self)!
      )
    }

    container.register(DetailHistoryBuilder.self, scope: .transient) {
      DetailHistoryBuilder(
        readingJourneyService: container.resolve(ReadingJourneyServicing.self)!
      )
    }

    container.register(CheckInWishTicketBuilder.self, scope: .transient) {
      CheckInWishTicketBuilder(
        readingJourneyService: container.resolve(ReadingJourneyServicing.self)!
      )
    }

    container.register(RegisterWishlistBuilder.self, scope: .transient) {
      RegisterWishlistBuilder()
    }

    container.register(JourneyTicketBuilder.self, scope: .transient) {
      JourneyTicketBuilder(
        readingJourneyService: container.resolve(ReadingJourneyServicing.self)!
      )
    }

    container.register(WishTicketBuilder.self, scope: .transient) {
      WishTicketBuilder(
        readingJourneyService: container.resolve(ReadingJourneyServicing.self)!
      )
    }

    container.register(RegisterHistoryBuilder.self, scope: .transient) {
      RegisterHistoryBuilder(
        readingJourneyService: container.resolve(ReadingJourneyServicing.self)!
      )
    }

    container.register(RegisterJourneyBuilder.self, scope: .transient) {
      RegisterJourneyBuilder()
    }

    container.register(JourneyBuilder.self, scope: .transient) {
      JourneyBuilder(
        journeyMemoService: container.resolve(JourneyMemoServicing.self)!,
        readingJourneyService: container.resolve(ReadingJourneyServicing.self)!,
        tooltipService: container.resolve(TooltipServicing.self)!
      )
    }
    
    container.register(SettingBuilder.self, scope: .transient) {
      SettingBuilder()
    }
    
    container.register(PrivacyPolicyBuilder.self, scope: .transient) {
      PrivacyPolicyBuilder()
    }
    
    container.register(TermsOfServiceBuilder.self, scope: .transient) {
      TermsOfServiceBuilder()
    }

    // MARK: - Coordinator
    // .singleton: 앱의 루트 코디네이터. 앱 생명주기 동안 하나만 존재해야 함
    container.register(AppCoordinator.self, scope: .singleton) {
      AppCoordinator(
        navigationController: navigationController,
        authService: container.resolve(AuthServicing.self)!,
        homeBuilder: container.resolve(HomeBuilder.self)!,
        loginBuilder: container.resolve(LoginBuilder.self)!,
        searchBuilder: container.resolve(SearchBuilder.self)!,
        wishlistBuilder: container.resolve(WishlistBuilder.self)!,
        checkInWishTicketBuilder: container.resolve(CheckInWishTicketBuilder.self)!,
        registerWishlistBuilder: container.resolve(RegisterWishlistBuilder.self)!,
        wishTicketBuilder: container.resolve(WishTicketBuilder.self)!,
        journeyTicketBuilder: container.resolve(JourneyTicketBuilder.self)!,
        registerHistoryBuilder: container.resolve(RegisterHistoryBuilder.self)!,
        registerJourneyBuilder: container.resolve(RegisterJourneyBuilder.self)!,
        jourenyBuilder: container.resolve(JourneyBuilder.self)!,
        historyBuilder: container.resolve(HistoryBuilder.self)!,
        detailHistoryBuilder: container.resolve(DetailHistoryBuilder.self)!,
        settingBuilder: container.resolve(SettingBuilder.self)!,
        privacyPolicyBuilder: container.resolve(PrivacyPolicyBuilder.self)!,
        termsOfServiceBuilder: container.resolve(TermsOfServiceBuilder.self)!
      )
    }
    
    // MARK: - Resolve root
    let coordinator = container.resolve(AppCoordinator.self)!

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    self.window = window
    self.appCoordinator = coordinator

    coordinator.start()
  }
}
