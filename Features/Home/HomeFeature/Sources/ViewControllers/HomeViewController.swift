//
//  HomeViewController.swift
//  Home
//
//  Created by 여성일 on 3/6/26.
//

import CoreLocation
import DesignSystem
import MapKit
import SnapKit
import Then
import UIKit
import HomeInterface

public final class HomeViewController: BaseViewController {
  public var onRoute: ((HomeRoute) -> Void)?
  
  private let viewModel: HomeViewModel
  
  private var flightAnnotations: [String: FlightAnnotation] = [:]
  private var flightRouteOverlays: [String: [MKPolyline]] = [:]
  
  private var hasInitiallyFocused = false
  private var lastJourneyCount = 0
  
  public init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    guard viewModel.journeys.isEmpty else { return }
    Task { [weak self] in
      await self?.viewModel.refresh()
    }
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
  
  private let settingButton = UIButton().then {
    $0.setImage(.settings, for: .normal)
    $0.tintColor = .n0
  }
  
  private let addButton = UIButton(configuration: .glass()).then {
    $0.setImage(.plus, for: .normal)
  }
  
  private let mapView = MKMapView().then {
    $0.showsCompass = false
    $0.showsScale = false
    $0.pointOfInterestFilter = .excludingAll
    $0.mapType = .satelliteFlyover
  }
  
  private let gradientOverlayView = GradientOverlayView()
  
  override public func configureUI() {
    [
      mapView,
      greetingLabel,
      tripCountLabel,
      totalDistanceLabel,
      settingButton,
      addButton
    ].forEach {
      view.addSubview($0)
    }
    
    registerForTraitChanges(
      [UITraitUserInterfaceStyle.self]
    ) { (self: Self, _) in
      self.applyMapTileTheme()
    }
    
    setupMapView()
    configureAddMenu()
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
    
    settingButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.trailing.equalToSuperview().inset(20)
      $0.width.height.equalTo(32)
    }
    
    addButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
      $0.trailing.equalToSuperview().inset(20)
      $0.width.height.equalTo(48)
    }
    
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    gradientOverlayView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override public func bind() {
    viewModel.onJourneysChanged = { [weak self] _ in
      guard let self else { return }
      
      DispatchQueue.main.async {
        self.updateSummaryUI()
        self.renderJourneys()
      }
    }
    
    viewModel.onError = { [weak self] message in
      DispatchQueue.main.async {
        self?.presentAlert(title: "불러오기 실패", message: message)
      }
    }
    
    settingButton.addTarget(self, action: #selector(didSetting), for: .touchUpInside)
    updateSummaryUI()
    renderJourneys()
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
      renderer.strokeColor = .l0
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
  
  public func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
    updateAllFlightAnnotationRotation()
  }
  
  public func mapView(
    _ mapView: MKMapView,
    didAdd views: [MKAnnotationView]
  ) {
    updateAllFlightAnnotationRotation()
  }
}

// MARK: - Private
private extension HomeViewController {
  @objc func didSetting() {
    onRoute?(.setting)
  }
  
  func configureAddMenu() {
    let wishlistAction = UIAction(title: "읽고 싶은 책") { [weak self] _ in
      self?.onRoute?(.wishlist)
    }
    
    let journeyAction = UIAction(title: "읽고 있는 책") { [weak self] _ in
      self?.onRoute?(.journey)
    }
    
    let historyAction = UIAction(title: "다 읽은 책") { [weak self] _ in
      self?.onRoute?(.history)
    }
    
    addButton.menu = UIMenu(children: [
      wishlistAction,
      journeyAction,
      historyAction
    ])
    
    addButton.showsMenuAsPrimaryAction = true
  }
  
  func updateSummaryUI() {
    var tripCountHighlight = AttributedString("\(viewModel.tripCount)개")
    tripCountHighlight.foregroundColor = UIColor.key0
    
    var tripCountText = AttributedString("의 여행 진행 중")
    tripCountText.foregroundColor = UIColor.n0
    
    tripCountHighlight.append(tripCountText)
    tripCountLabel.attributedText = NSAttributedString(tripCountHighlight)
    
    var totalDistancePrefixText = AttributedString("총 ")
    totalDistancePrefixText.foregroundColor = UIColor.n0
    
    var totalDistanceHighlight = AttributedString("\(viewModel.totalDistance.formattedWithComma) km")
    totalDistanceHighlight.foregroundColor = UIColor.key0
    
    var totalDistanceSuffixText = AttributedString(" 여행")
    totalDistanceSuffixText.foregroundColor = UIColor.n0
    
    totalDistancePrefixText.append(totalDistanceHighlight)
    totalDistancePrefixText.append(totalDistanceSuffixText)
    totalDistanceLabel.attributedText = NSAttributedString(totalDistancePrefixText)
    
    greetingLabel.text = viewModel.greetingText
  }
  
  private func applyMapTileTheme() {
    mapView.removeOverlays(
      mapView.overlays.compactMap { $0 as? MKTileOverlay }
    )
    
    let urlTemplate = traitCollection.userInterfaceStyle == .dark ? MapTile.darkNolabels : MapTile.lightNolabels
    
    let tileOverlay = CachedMapTileOverlay(urlTemplate: urlTemplate)
    tileOverlay.canReplaceMapContent = true
    
    mapView.addOverlay(tileOverlay, level: .aboveRoads)
    
    let polylines = mapView.overlays.compactMap { $0 as? MKPolyline }

    mapView.removeOverlays(polylines)
    mapView.addOverlays(polylines)
  }
}

// MARK: - MapView
private extension HomeViewController {
  enum Constants {
    static let routeSampleCount = 120
    static let flightAngleSampleOffset = 0.01
    static let minimumLatitudeDelta = 8.0
    static let minimumLongitudeDelta = 8.0
  }
  
  func setupMapView() {
    mapView.delegate = self
    mapView.addSubview(gradientOverlayView)

    applyMapTileTheme()
  }
  
  /// 현재 여행 목록을 기반으로 공항 어노테이션, 비행 경로, 비행기 어노테이션을 지도에 렌더링합니다.
  func renderJourneys() {
    mapView.removeAnnotations(mapView.annotations)
    
    let overlaysToRemove = mapView.overlays.filter { !($0 is MKTileOverlay) }
    mapView.removeOverlays(overlaysToRemove)
    
    flightAnnotations.removeAll()
    flightRouteOverlays.removeAll()
    
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
      
      let progress = clampedProgress(viewModel.calculateProgress(journey: journey))
      
      let departureAnnotation = AirportAnnotation(
        iconType: .departure,
        code: journey.departureAirport.iata,
        coordinate: departureCoordinate.normalizedLongitudeCoordinate
      )
      
      let arrivalAnnotation = AirportAnnotation(
        iconType: .arrival,
        code: journey.arrivalAirport.iata,
        coordinate: arrivalCoordinate.normalizedLongitudeCoordinate
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
    }
    
    let currentCount = journeys.count
    
    if !hasInitiallyFocused || currentCount > lastJourneyCount {
      focusLatestJourney()
      hasInitiallyFocused = true
    }
    
    lastJourneyCount = currentCount
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
      self?.updateAllFlightAnnotationRotation()
    }
  }
  
  /// 출발 공항에서 도착 공항까지의 비행 경로를 여러 점으로 샘플링하여 지도에 polyline으로 추가합니다.
  func addFlightRoute(
    journeyId: String,
    departure: CLLocationCoordinate2D,
    arrival: CLLocationCoordinate2D
  ) {
    let sampledCoordinates = sampledRouteCoordinates(
      departure: departure,
      arrival: arrival,
      sampleCount: Constants.routeSampleCount
    )
    
    let routeSegments = splitRouteAtDateLineIfNeeded(sampledCoordinates)
    
    var polylines: [MKPolyline] = []
    
    for segment in routeSegments where segment.count >= 2 {
      let polyline = MKPolyline(coordinates: segment, count: segment.count)
      polylines.append(polyline)
      mapView.addOverlay(polyline)
    }
    
    flightRouteOverlays[journeyId] = polylines
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
  /// 날짜변경선을 고려하여 더 짧은 방향으로 경도를 보간하고, 결과 경도는 -180...180 범위로 정규화합니다.
  func interpolatedCoordinate(
    start: CLLocationCoordinate2D,
    end: CLLocationCoordinate2D,
    progress: Double
  ) -> CLLocationCoordinate2D {
    let clamped = clampedProgress(progress)
    
    let lat = start.latitude + (end.latitude - start.latitude) * clamped
    
    var deltaLng = end.longitude - start.longitude
    if deltaLng > 180 { deltaLng -= 360 }
    if deltaLng < -180 { deltaLng += 360 }
    
    let lng = normalizeLongitude(start.longitude + deltaLng * clamped)
    return CLLocationCoordinate2D(latitude: lat, longitude: lng)
  }
  
  /// 비행기 어노테이션이 바라봐야 할 회전 각도를 계산합니다.
  /// 출발 공항 -> 도착 공항 경로 기준으로 화면 좌표에서의 진행 방향을 구합니다.
  func flightRotationAngle(
    start: CLLocationCoordinate2D,
    end: CLLocationCoordinate2D,
    progress: Double
  ) -> CGFloat {
    let previousProgress = max(0.0, progress - Constants.flightAngleSampleOffset)
    let nextProgress = min(1.0, progress + Constants.flightAngleSampleOffset)
    
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
  
  // 모든 비행기 어노테이션의 회전 값을 업데이트합니다.
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
      
      let progress = clampedProgress(viewModel.calculateProgress(journey: journey))
      
      updateFlightAnnotationRotation(
        journeyId: journey.id,
        departure: departureCoordinate,
        arrival: arrivalCoordinate,
        progress: progress
      )
    }
  }
  
  // 최신 여행이 날짜변경선을 지나도 포커싱이 엉뚱한 곳으로 튀지 않도록
  // 일반 경도계와 음수 경도 360 경도계를 모두 비교해서 더 좁은 bounds를 선택
  func focusLatestJourney() {
    guard let latestJourney = viewModel.latestJourney else { return }
    
    let departure = CLLocationCoordinate2D(
      latitude: latestJourney.departureAirport.latitude,
      longitude: latestJourney.departureAirport.longitude
    )
    
    let arrival = CLLocationCoordinate2D(
      latitude: latestJourney.arrivalAirport.latitude,
      longitude: latestJourney.arrivalAirport.longitude
    )
    
    let progress = clampedProgress(viewModel.calculateProgress(journey: latestJourney))
    
    let routeCoordinates = sampledRouteCoordinates(
      departure: departure,
      arrival: arrival,
      sampleCount: Constants.routeSampleCount
    )
    
    let flightCoordinate = interpolatedCoordinate(
      start: departure,
      end: arrival,
      progress: progress
    )
    
    let allCoordinates = routeCoordinates + [flightCoordinate]
    guard !allCoordinates.isEmpty else { return }
    
    let region = bestFittingRegion(for: allCoordinates)
    mapView.setRegion(mapView.regionThatFits(region), animated: true)
  }
}

// MARK: - Helpers
private extension HomeViewController {
  typealias CoordinateBounds = (
    centerLatitude: Double,
    centerLongitude: Double,
    latitudeDelta: Double,
    longitudeDelta: Double
  )
  
  func clampedProgress(_ progress: Double) -> Double {
    min(max(progress, 0.0), 1.0)
  }
  
  func normalizeLongitude(_ longitude: Double) -> Double {
    var lng = longitude
    while lng > 180 { lng -= 360 }
    while lng < -180 { lng += 360 }
    return lng
  }
  
  func sampledRouteCoordinates(
    departure: CLLocationCoordinate2D,
    arrival: CLLocationCoordinate2D,
    sampleCount: Int
  ) -> [CLLocationCoordinate2D] {
    guard sampleCount > 0 else {
      return [
        departure.normalizedLongitudeCoordinate,
        arrival.normalizedLongitudeCoordinate
      ]
    }
    
    return (0...sampleCount).map { index in
      let progress = Double(index) / Double(sampleCount)
      return interpolatedCoordinate(
        start: departure,
        end: arrival,
        progress: progress
      )
    }
  }
  
  func bestFittingRegion(
    for coordinates: [CLLocationCoordinate2D]
  ) -> MKCoordinateRegion {
    let normalBounds = coordinateBounds(
      for: coordinates,
      shiftNegativeLongitude: false
    )
    
    let shiftedBounds = coordinateBounds(
      for: coordinates,
      shiftNegativeLongitude: true
    )
    
    let selectedBounds = shiftedBounds.longitudeDelta < normalBounds.longitudeDelta
    ? shiftedBounds
    : normalBounds
    
    let centerLongitude = normalizeLongitude(selectedBounds.centerLongitude)
    
    return MKCoordinateRegion(
      center: CLLocationCoordinate2D(
        latitude: selectedBounds.centerLatitude,
        longitude: centerLongitude
      ),
      span: MKCoordinateSpan(
        latitudeDelta: max(selectedBounds.latitudeDelta * 1.4, Constants.minimumLatitudeDelta),
        longitudeDelta: max(selectedBounds.longitudeDelta * 1.4, Constants.minimumLongitudeDelta)
      )
    )
  }
  
  func coordinateBounds(
    for coordinates: [CLLocationCoordinate2D],
    shiftNegativeLongitude: Bool
  ) -> CoordinateBounds {
    var minLat = Double.greatestFiniteMagnitude
    var maxLat = -Double.greatestFiniteMagnitude
    var minLng = Double.greatestFiniteMagnitude
    var maxLng = -Double.greatestFiniteMagnitude
    
    for coordinate in coordinates {
      let lat = coordinate.latitude
      var lng = coordinate.longitude
      
      if shiftNegativeLongitude && lng < 0 {
        lng += 360
      }
      
      minLat = min(minLat, lat)
      maxLat = max(maxLat, lat)
      minLng = min(minLng, lng)
      maxLng = max(maxLng, lng)
    }
    
    return (
      centerLatitude: (minLat + maxLat) / 2,
      centerLongitude: (minLng + maxLng) / 2,
      latitudeDelta: maxLat - minLat,
      longitudeDelta: maxLng - minLng
    )
  }
  
  // 날짜변경선을 넘는 경우에도 선이 끊기지 않도록
  // 경계점(180, -180)을 삽입해서 양쪽 segment를 자연스럽게 이어줌
  func splitRouteAtDateLineIfNeeded(
    _ coordinates: [CLLocationCoordinate2D]
  ) -> [[CLLocationCoordinate2D]] {
    guard coordinates.count >= 2 else {
      return coordinates.isEmpty ? [] : [coordinates]
    }
    
    var result: [[CLLocationCoordinate2D]] = []
    var currentSegment: [CLLocationCoordinate2D] = [coordinates[0]]
    
    for index in 1..<coordinates.count {
      let previous = coordinates[index - 1]
      let current = coordinates[index]
      
      let rawGap = current.longitude - previous.longitude
      
      if abs(rawGap) <= 180 {
        currentSegment.append(current)
        continue
      }
      
      let crossingLatitude = interpolatedLatitudeAtDateLineCrossing(
        from: previous,
        to: current
      )
      
      let minus180 = CLLocationCoordinate2D(
        latitude: crossingLatitude,
        longitude: -180
      )
      
      let plus180 = CLLocationCoordinate2D(
        latitude: crossingLatitude,
        longitude: 180
      )
      
      if rawGap > 180 {
        currentSegment.append(minus180)
        if currentSegment.count >= 2 {
          result.append(currentSegment)
        }
        
        currentSegment = [plus180, current]
      } else {
        currentSegment.append(plus180)
        if currentSegment.count >= 2 {
          result.append(currentSegment)
        }
        
        currentSegment = [minus180, current]
      }
    }
    
    if currentSegment.count >= 2 {
      result.append(currentSegment)
    }
    
    return result
  }
  
  // 날짜변경선을 넘는 두 점 사이에서 경계선을 지나는 대략적인 위도를 계산
  func interpolatedLatitudeAtDateLineCrossing(
    from start: CLLocationCoordinate2D,
    to end: CLLocationCoordinate2D
  ) -> Double {
    let startLng = start.longitude
    var endLng = end.longitude
    
    if endLng - startLng > 180 {
      endLng -= 360
    } else if endLng - startLng < -180 {
      endLng += 360
    }
    
    let targetLng: Double = startLng < endLng ? 180 : -180
    let denominator = endLng - startLng
    
    guard denominator != 0 else { return start.latitude }
    
    let t = (targetLng - startLng) / denominator
    return start.latitude + (end.latitude - start.latitude) * t
  }
}


