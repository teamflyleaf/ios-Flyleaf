//
//  TicketShapeView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/16/26.
//

import Then
import SnapKit
import UIKit

/// 항공권(티켓)의 쉐잎(형태)를 표현하는 커스텀 뷰입니다.
///
/// 좌우에 반원 형태의 노치와 점선을 포함한 티켓 UI의 뼈대를 구성합니다.
///
/// ```swift
/// let ticketView = TicketShapeView()
/// ```
final class TicketShapeView: BaseView {
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
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updateShape()
  }
  
  override func configureUI() {
    // 쉐잎 마스크 적용: 티켓 모양으로 잘림.
    layer.mask = shapeMaskLayer
    
    layer.addSublayer(dashedLineLayer)
    
    backgroundColor = .n60
    
    dashedLineLayer.strokeColor = UIColor.n0.withAlphaComponent(0.5).cgColor
    dashedLineLayer.lineWidth = 1
    dashedLineLayer.lineDashPattern = [2, 3] // 점선 패턴
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
    
    let borderPath = UIBezierPath()
    borderPath.append(outerPath)
    borderPath.append(leftNotchPath)
    borderPath.append(rightNotchPath)
    
    // 절취선
    let dashY = notchCenterY
    let dashPath = UIBezierPath()
    dashPath.move(to: CGPoint(x: 20, y: dashY))
    dashPath.addLine(to: CGPoint(x: rect.width - 20, y: dashY))
    dashedLineLayer.path = dashPath.cgPath
  }
}
