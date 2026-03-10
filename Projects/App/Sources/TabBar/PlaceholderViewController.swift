//
//  PlaceholderViewController.swift
//  FlyleafDev
//
//  Created by 여성일 on 3/11/26.
//

import DesignSystem
import SnapKit
import Then
import UIKit

/*
 TabBar 테스트용 Mock ViewController 입니다.
 다른 Feature 모듈 생성 및 탭바 연결 시 삭제 예정입니다.
 */
final class PlaceholderViewController: BaseViewController {
  let label = UILabel().then {
    $0.text = "테스트 뷰컨"
  }
  
  override func configureUI() {
    view.addSubview(label)
  }
  
  override func setupLayout() {
    label.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
}
