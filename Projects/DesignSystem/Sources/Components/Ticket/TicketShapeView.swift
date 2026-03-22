//
//  TicketShapeView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/16/26.
//

import Then
import SnapKit
import UIKit


enum TicketShapeMode {
  case full
  case topOnly
}

/// 항공권(티켓)의 쉐입(형태)를 표현하는 커스텀 뷰입니다.
///
/// 좌우에 반원 형태의 노치와 점선을 포함한 티켓 UI의 뼈대를 구성합니다.
///
/// ```swift
/// let fullTicketView = TicketShapeView()
/// let topOnlyTicketView = TicketShapeView(mode: .topOnly)
/// ```
///
/// - Note:
///   - 기본 모드는 `.full`입니다.
///   - `.full`은 전체 티켓 형태를, `.topOnly`는 하단이 잘린 상단 티켓 형태를 표현합니다.
final class TicketShapeView: BaseView {
  enum Mode {
    case full
    case topOnly
  }
  
  private let mode: Mode
  private let cornerRadius: CGFloat = 12
  
  // 좌우 반원(노치) 반지름
  private let notchRadius: CGFloat = 16
  
  // 하단 쪽 경계 위치(노치 위치) 비율
  private let notchCenterYRatio: CGFloat = 0.78
  
  // 쉐잎 레이어
  private let shapeMaskLayer = CAShapeLayer()
  
  // 절취선(점선) 레이어
  private let dashedLineLayer = CAShapeLayer()
  
  // MARK: - UI
  private let worldMap = UIImageView().then {
    $0.image = .worldMap
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .n20
  }
  
  init(mode: Mode = .full) {
    self.mode = mode
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateShape()
  }
  
  override func configureUI() {
    layer.mask = shapeMaskLayer
    layer.addSublayer(dashedLineLayer)
    
    backgroundColor = .n60
    
    dashedLineLayer.strokeColor = UIColor.n0.withAlphaComponent(0.5).cgColor
    dashedLineLayer.lineWidth = 1
    dashedLineLayer.lineDashPattern = [2, 3]
    dashedLineLayer.fillColor = UIColor.clear.cgColor
    
    addSubview(worldMap)
  }
  
  override func setupLayout() {
    worldMap.snp.makeConstraints {
      $0.top.equalToSuperview().offset(15)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(162)
    }
  }
}

// MARK: - Private
private extension TicketShapeView {
  // 티켓 형태 path 생성 및 레이어 업데이트
  func updateShape() {
    let rect = bounds
    
    guard rect.width > 0, rect.height > 0 else { return }
    
    switch mode {
    case .full:
      updateFullShape(in: rect)
    case .topOnly:
      updateTopOnlyShape(in: rect)
    }
  }
  
  func updateFullShape(in rect: CGRect) {
    // 노치 중심 Y좌표 계산
    let notchCenterY = rect.height * notchCenterYRatio
    
    // 기본 라운드 사각형
    let outerPath = UIBezierPath(
      roundedRect: rect,
      cornerRadius: cornerRadius
    )
    
    // 좌측 노치
    let leftNotchRect = CGRect(
      x: -notchRadius,
      y: notchCenterY - notchRadius,
      width: notchRadius * 2,
      height: notchRadius * 2
    )
    
    // 우측 노치
    let rightNotchRect = CGRect(
      x: rect.width - notchRadius,
      y: notchCenterY - notchRadius,
      width: notchRadius * 2,
      height: notchRadius * 2
    )
    
    let leftNotchPath = UIBezierPath(ovalIn: leftNotchRect)
    let rightNotchPath = UIBezierPath(ovalIn: rightNotchRect)
    
    // outer + notch를 통해 구멍이 뚫린 형태로 형태를 생성함.
    let combinedPath = UIBezierPath()
    combinedPath.append(outerPath)
    combinedPath.append(leftNotchPath)
    combinedPath.append(rightNotchPath)
    
    // evenOdd로 노치 부분이 실제로 잘려나감
    shapeMaskLayer.path = combinedPath.cgPath
    shapeMaskLayer.fillRule = .evenOdd
    
    // 절취선
    let dashPath = UIBezierPath()
    dashPath.move(to: CGPoint(x: 20, y: notchCenterY))
    dashPath.addLine(to: CGPoint(x: rect.width - 20, y: notchCenterY))
    dashedLineLayer.path = dashPath.cgPath
    dashedLineLayer.isHidden = false
  }
  
  func updateTopOnlyShape(in rect: CGRect) {
    let topOnlyPath = makeTopOnlyPath(in: rect)
    
    shapeMaskLayer.path = topOnlyPath.cgPath
    shapeMaskLayer.fillRule = .nonZero
    
    dashedLineLayer.isHidden = true
    dashedLineLayer.path = nil
  }
  
  func makeTopOnlyPath(in rect: CGRect) -> UIBezierPath {
    let notchCenterY = rect.maxY
    
    let path = UIBezierPath()
    
    // 시작점: 좌상단 라운드 시작
    path.move(to: CGPoint(x: cornerRadius, y: 0))
    
    // 상단 직선
    path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
    
    // 우상단 라운드
    path.addArc(
      withCenter: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
      radius: cornerRadius,
      startAngle: -.pi / 2,
      endAngle: 0,
      clockwise: true
    )
    
    // 오른쪽 내려가기 (노치 위까지)
    path.addLine(to: CGPoint(x: rect.width, y: notchCenterY - notchRadius))
    
    // 오른쪽 노치
    path.addArc(
      withCenter: CGPoint(x: rect.width, y: notchCenterY),
      radius: notchRadius,
      startAngle: -.pi / 2,
      endAngle: .pi / 2,
      clockwise: false
    )
    
    // 하단 직선 (오른쪽 노치 아래 → 왼쪽 노치 아래)
    path.addLine(to: CGPoint(x: 0, y: notchCenterY + notchRadius))
    
    // 왼쪽 노치
    path.addArc(
      withCenter: CGPoint(x: 0, y: notchCenterY),
      radius: notchRadius,
      startAngle: .pi / 2,
      endAngle: -.pi / 2,
      clockwise: false
    )
    
    // 왼쪽 올라가기
    path.addLine(to: CGPoint(x: 0, y: cornerRadius))
    
    // 좌상단 라운드
    path.addArc(
      withCenter: CGPoint(x: cornerRadius, y: cornerRadius),
      radius: cornerRadius,
      startAngle: .pi,
      endAngle: -.pi / 2,
      clockwise: true
    )
    
    path.close()
    return path
  }
}
