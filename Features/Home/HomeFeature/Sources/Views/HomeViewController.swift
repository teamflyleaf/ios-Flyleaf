//
//  HomeViewController.swift
//  Home
//
//  Created by 여성일 on 3/6/26.
//

import DesignSystem
import MapKit
import SnapKit
import Then
import UIKit

public final class HomeViewController: BaseViewController {
  private let viewModel: HomeViewModel
  private var didRenderJourneys = false

  private var flightAnnotations: [String: FlightAnnotation] = [:]
  private var flightRouteOverlays: [String: MKPolyline] = [:]

  public init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    guard !didRenderJourneys else { return }
    didRenderJourneys = true
    
    renderJourneys()
  }
  
  // MARK: - UI
  private let greetingLabel = UILabel().then {
    $0.font = .h4_m
    $0.textColor = .n0
  }
  
  private let tripCountLabel = UILabel().then {
    $0.font = .h1
  }
  
  private let totalDistanceLabel = UILabel().then {
    $0.font = .b1_m
  }
  
  private let mapView = MKMapView().then {
    $0.showsCompass = false
    $0.showsScale = false
    $0.pointOfInterestFilter = .excludingAll
    $0.mapType = .hybridFlyover
  }
  
  private let gradientOverlayView = GradientOverlayView()
  
  override public func configureUI() {
    [mapView, greetingLabel, tripCountLabel, totalDistanceLabel].forEach {
      view.addSubview($0)
    }
    
    setupMapView()
  }
  
  override public func setupLayout() {
    greetingLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(20)
    }
    
    tripCountLabel.snp.makeConstraints {
      $0.top.equalTo(greetingLabel.snp.bottom).offset(14)
      $0.leading.equalToSuperview().offset(20)
    }
    
    totalDistanceLabel.snp.makeConstraints {
      $0.top.equalTo(tripCountLabel.snp.bottom).offset(6)
      $0.leading.equalToSuperview().offset(20)
    }
    
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    gradientOverlayView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override public func bind() {
    var tripCountHighlight = AttributedString("\(viewModel.tripCount)개")
    tripCountHighlight.foregroundColor = UIColor.key0
    
    var tripCountText = AttributedString("의 여행 진행 중")
    tripCountText.foregroundColor = UIColor.n0
    
    tripCountHighlight.append(tripCountText)
    tripCountLabel.attributedText = NSAttributedString(tripCountHighlight)
    
    var totalDistancePrefixText = AttributedString("총 ")
    totalDistancePrefixText.foregroundColor = UIColor.n0
    
    var totalDistanceHighlight = AttributedString("\(viewModel.totalDistance) km")
    totalDistanceHighlight.foregroundColor = UIColor.key0
    
    var totalDistanceSuffixText = AttributedString(" 여행")
    totalDistanceSuffixText.foregroundColor = UIColor.n0
    
    totalDistancePrefixText.append(totalDistanceHighlight)
    totalDistancePrefixText.append(totalDistanceSuffixText)
    totalDistanceLabel.attributedText = NSAttributedString(totalDistancePrefixText)
    
    greetingLabel.text = viewModel.greetingText
  }
}

// MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
  public func mapView(
    _ mapView: MKMapView,
    rendererFor overlay: MKOverlay
  ) -> MKOverlayRenderer {
    if let polyline = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: polyline)
      renderer.strokeColor = .n0.withAlphaComponent(0.5)
      renderer.lineWidth = 0.5
      renderer.lineCap = .round
      renderer.lineJoin = .round
      return renderer
    }
    
    if let tileOverlay = overlay as? MKTileOverlay {
      return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
    
    return MKOverlayRenderer(overlay: overlay)
  }
  
  public func mapView(
    _ mapView: MKMapView,
    viewFor annotation: any MKAnnotation
  ) -> MKAnnotationView? {
    if let airportAnnotation = annotation as? AirportAnnotation {
      let view = mapView.dequeueReusableAnnotationView(
        withIdentifier: AirportAnnotationView.identifier
      ) as? AirportAnnotationView ?? AirportAnnotationView(
        annotation: airportAnnotation,
        reuseIdentifier: AirportAnnotationView.identifier
      )

      view.annotation = airportAnnotation
      view.configure(annotation: airportAnnotation)
      return view
    }

    if let flightAnnotation = annotation as? FlightAnnotation {
      let view = mapView.dequeueReusableAnnotationView(
        withIdentifier: FlightAnnotationView.identifier
      ) as? FlightAnnotationView ?? FlightAnnotationView(
        annotation: flightAnnotation,
        reuseIdentifier: FlightAnnotationView.identifier
      )

      view.annotation = flightAnnotation
      return view
    }

    return nil
  }
  
  public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    updateAllFlightAnnotationRotation()
  }
}

// MARK: - Private
private extension HomeViewController {
  func setupMapView() {
    mapView.delegate = self
    mapView.addSubview(gradientOverlayView)
  
    let tileOverlay = MKTileOverlay(
      urlTemplate: MapTile.darkNolabels
    )
    tileOverlay.canReplaceMapContent = true
    mapView.addOverlay(tileOverlay, level: .aboveRoads)
  }
  
  /// 현재 여행 목록을 기반으로 공항 어노테이션, 비행 경로, 비행기 어노테이션을 지도에 렌더링합니다.
  func renderJourneys() {
    let journeys = viewModel.journeys
    
    for journey in journeys {
      let departureCoordinate = CLLocationCoordinate2D(
        latitude: journey.departureAirport.latitude,
        longitude: journey.departureAirport.longitude
      )
      
      let arrivalCoordinate = CLLocationCoordinate2D(
        latitude: journey.arrivalAirport.latitude,
        longitude: journey.arrivalAirport.longitude
      )
      
      let progress = viewModel.calculateProgress(journey: journey)
      
      let departureAnnotation = AirportAnnotation(
        iconType: .departure,
        code: journey.departureAirport.code,
        coordinate: departureCoordinate
      )
      
      let arrivalAnnotation = AirportAnnotation(
        iconType: .arrival,
        code: journey.arrivalAirport.code,
        coordinate: arrivalCoordinate
      )
      
      mapView.addAnnotations([departureAnnotation, arrivalAnnotation])
      
      addFlightRoute(
        journeyId: journey.id,
        departure: departureCoordinate,
        arrival: arrivalCoordinate
      )
      
      addFlightAnnotation(
        journeyId: journey.id,
        departure: departureCoordinate,
        arrival: arrivalCoordinate,
        progress: progress
      )
      
      mapView.showAnnotations(mapView.annotations, animated: false)
      
      DispatchQueue.main.async { [weak self] in
        self?.updateAllFlightAnnotationRotation()
      }
    }
  }
  
  /// 출발 공항에서 도착 공항까지의 비행 경로를 지도에 polyline으로 추가합니다.
  func addFlightRoute(
    journeyId: String,
    departure: CLLocationCoordinate2D,
    arrival: CLLocationCoordinate2D
  ) {
    let coordinates = [departure, arrival]
    let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
    flightRouteOverlays[journeyId] = polyline
    mapView.addOverlay(polyline)
  }
  
  /// 출발 공항과 도착 공항 사이 경로 위에 비행기 어노테이션을 추가합니다.
  /// progress 값에 따라 비행기 위치가 결정됩니다.
  func addFlightAnnotation(
    journeyId: String,
    departure: CLLocationCoordinate2D,
    arrival: CLLocationCoordinate2D,
    progress: Double
  ) {
    let coordinate = interpolatedCoordinate(
      start: departure,
      end: arrival,
      progress: progress
    )
    
    let annotation = FlightAnnotation(coordinate: coordinate)
    flightAnnotations[journeyId] = annotation
    mapView.addAnnotation(annotation)
  }
  
  /// 출발 좌표와 도착 좌표 사이에서 progress 위치의 좌표를 계산합니다.
  /// progress 값(0.0 ~ 1.0)에 따라 경로 위의 중간 좌표를 반환합니다.
  func interpolatedCoordinate(
    start: CLLocationCoordinate2D,
    end: CLLocationCoordinate2D,
    progress: Double
  ) -> CLLocationCoordinate2D {
    let startPoint = MKMapPoint(start)
    let endPoint = MKMapPoint(end)
    
    let x = startPoint.x + (endPoint.x - startPoint.x) * progress
    let y = startPoint.y + (endPoint.y - startPoint.y) * progress
    
    return MKMapPoint(x: x, y: y).coordinate
  }
  
  /// 비행기 어노테이션이 바라봐야 할 회전 각도를 계산합니다.
  /// 출발 공항 -> 도착 공항 경로 기준으로 화면 좌표에서의 진행 방향을 구합니다.
  func flightRotationAngle(
    start: CLLocationCoordinate2D,
    end: CLLocationCoordinate2D,
    progress: Double
  ) -> CGFloat {
    let previousProgress = max(0.0, progress - 0.01)
    let nextProgress = min(1.0, progress + 0.01)

    let previousCoordinate = interpolatedCoordinate(
      start: start,
      end: end,
      progress: previousProgress
    )

    let nextCoordinate = interpolatedCoordinate(
      start: start,
      end: end,
      progress: nextProgress
    )

    let previousPoint = mapView.convert(previousCoordinate, toPointTo: mapView)
    let nextPoint = mapView.convert(nextCoordinate, toPointTo: mapView)

    let dx = nextPoint.x - previousPoint.x
    let dy = nextPoint.y - previousPoint.y

    return atan2(dy, dx)
  }
  
  /// 비행기 어노테이션의 회전 값을 업데이트합니다.
  /// 현재 지도 상태를 기준으로 비행기 어노테이션의 방향을 갱신합니다.
  func updateFlightAnnotationRotation(
    journeyId: String,
    departure: CLLocationCoordinate2D,
    arrival: CLLocationCoordinate2D,
    progress: Double
  ) {
    guard
      let flightAnnotation = flightAnnotations[journeyId],
      let view = mapView.view(for: flightAnnotation) as? FlightAnnotationView
    else { return }

    let angle = flightRotationAngle(
      start: departure,
      end: arrival,
      progress: progress
    )

    view.setRotation(angle)
  }
  
  /// 모든 비행기 어노테이션의 회전 값을 업데이트합니다.
  /// 현재 지도 상태를 기준으로 모든 비행기 어노테이션의 방향을 갱신합니다.
  func updateAllFlightAnnotationRotation() {
    for journey in viewModel.journeys {
      let departureCoordinate = CLLocationCoordinate2D(
        latitude: journey.departureAirport.latitude,
        longitude: journey.departureAirport.longitude
      )

      let arrivalCoordinate = CLLocationCoordinate2D(
        latitude: journey.arrivalAirport.latitude,
        longitude: journey.arrivalAirport.longitude
      )

      let progress = viewModel.calculateProgress(journey: journey)

      updateFlightAnnotationRotation(
        journeyId: journey.id,
        departure: departureCoordinate,
        arrival: arrivalCoordinate,
        progress: progress
      )
    }
  }
}
