//
//  AirportAnnotationView.swift
//  Home
//
//  Created by 여성일 on 3/9/26.
//

import MapKit
import SnapKit
import Then
import UIKit

/// 공항 마커를 표시하는 커스텀 `MKAnnotationView` 입니다.
///
/// `AirportAnnotaion`의 데이터를 기반으로
/// 공항 코드와 출발/도착 아이콘을 함께 표시합니다.
final class AirportAnnotationView: MKAnnotationView {
  static let identifier = "AirportAnnotationView"
  
  // MARK: - UI
  private let iconImageView = UIImageView().then {
    $0.tintColor = .black
  }
  
  private let codeLabel = UILabel().then {
    $0.font = .b3_sb
    $0.textColor = .n70
  }
  
  override init(
    annotation: MKAnnotation?,
    reuseIdentifier: String?
  ) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    configureUI()
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    codeLabel.text = nil
  }
  
  // MARK: - Public Method
  func configure(annotation: AirportAnnotation) {
    codeLabel.text = annotation.code
    iconImageView.image = annotation.iconType.image
  }
}

// MARK: - Private
private extension AirportAnnotationView {
  func configureUI() {
    frame = CGRect(x: 0, y: 0, width: 44, height: 20)
    backgroundColor = .key0
    layer.borderWidth = 2
    layer.borderColor = UIColor.n70.cgColor
    layer.cornerRadius = 4
    layer.masksToBounds = true
    
    canShowCallout = false
    
    [iconImageView, codeLabel].forEach {
      addSubview($0)
    }
  }
  
  func setupLayout() {
    iconImageView.snp.makeConstraints {
      $0.width.height.equalTo(12)
      $0.leading.equalToSuperview().offset(4)
      $0.centerY.equalToSuperview()
    }
    
    codeLabel.snp.makeConstraints {
      $0.leading.equalTo(iconImageView.snp.trailing).offset(4)
      $0.trailing.equalToSuperview().inset(4)
      $0.centerY.equalToSuperview()
    }
  }
}
