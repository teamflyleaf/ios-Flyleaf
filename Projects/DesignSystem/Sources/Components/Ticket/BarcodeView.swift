//
//  BarcodeView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/16/26.
//

import UIKit

/// 간단한 바코드 형태를 그리는 커스텀 뷰입니다.
///
/// ```swift
/// let barcodeView = BarcodeView()
/// ```
///
/// - Note:
///   - `draw(_:)`를 사용하여 Core Graphics로 직접 렌더링합니다.
///   - 뷰의 width에 맞춰 패턴이 반복됩니다.
final class BarcodeView: BaseView {
  override func configureUI() {
    self.backgroundColor = .clear
  }
  
  override func draw(_ rect: CGRect) {
    // Core Graphics Context 불러오기
    guard let ctx = UIGraphicsGetCurrentContext() else { return }
    
    // 막대 색상 설정
    ctx.setFillColor(UIColor.n0.cgColor)
    
    // 바코드 패턴(막대 너비)
    // 값이 더 클수록 더 두꺼운 막대
    // TODO: 랜덤 바코드를 위한 랜덤 패턴으로 리팩토링 가능성 생각해보기
    let pattern: [CGFloat] = [
      3, 1, 5, 2, 4, 2, 6, 1, 3, 2
    ]
    
    // 막대 사이 간격
    let spacing: CGFloat = 4
    
    // 현재 바코드 그릴 x좌표
    var x: CGFloat = 0
    
    // 패턴 인덱스 (반복을 위한 인덱스 값임.)
    var index = 0
    
    // 뷰 너비 끝까지 반복해서 바코드를 채움.
    while x < rect.width {
      
      // 현재 패턴에 해당하는 막대 너비
      let width = pattern[index % pattern.count]
      
      // 세로 막대 그리기
      ctx.fill(
        CGRect(
          x: x,
          y: 0,
          width: width,
          height: rect.height
        )
      )
      // 다음 위치로 이동 (막대 너비 + 간격)
      x += width + spacing
      
      // 다음 패턴으로 이동
      index += 1
    }
  }
}
