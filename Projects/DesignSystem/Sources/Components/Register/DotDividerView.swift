//
//  DotDividerView.swift
//  DesignSystem
//
//  Created by 여성일 on 3/16/26.
//

import UIKit
import Then

/// 양 끝에 점이 포함된 디바이더 컴포넌트 입니다.
///
/// ```swift
/// let divider = DotDividerView()
/// ```
///
/// - Note:
///   - 높이는 `weight + 2`로 계산됩니다.
///   - 중앙 라인의 두께(`weight`)와 색상은 커스터마이징 가능합니다.
///   - dot은 고정 크기(3pt) 입니다.
public final class DotDividerView: BaseView {
  // 기본 높이 설정: 55
  public override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: weight + 2)
  }
  
  private let lineColor: UIColor
  private let dotColor: UIColor
  private let weight: CGFloat
  
  // MARK: - UI
  private let leftDotView = UIView().then {
    $0.layer.cornerRadius = 1.5
  }
  
  private let lineView = UIView()
  
  private let rightDotView = UIView().then {
    $0.layer.cornerRadius = 1.5
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 2
    $0.alignment = .center
  }
  
  /// - Parameters:
  ///   - lineColor: 중앙 라인의 색상 (기본값: n0)
  ///   - dotColor: 좌우 점의 색상 (기본값: n0)
  ///   - weight: 중앙 라인의 두께
  public init(
    lineColor: UIColor = .n0,
    dotColor: UIColor = .n0,
    weight: CGFloat = 1
  ) {
    self.lineColor = lineColor
    self.dotColor = dotColor
    self.weight = weight
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  public override func configureUI() {
    addSubview(stackView)
    
    [
      leftDotView,
      lineView,
      rightDotView
    ].forEach {
      stackView.addArrangedSubview($0)
    }
    
    leftDotView.backgroundColor = dotColor
    rightDotView.backgroundColor = dotColor
    lineView.backgroundColor = lineColor
  }
  
  public override func setupLayout() {
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    [
      leftDotView,
      rightDotView
    ].forEach {
      $0.snp.makeConstraints {
        $0.size.equalTo(3)
      }
    }
    
    lineView.snp.makeConstraints {
      $0.height.equalTo(weight)
    }
  }
}
