//
//  ReasonProvider.swift
//  Core
//
//  Created by 여성일 on 3/20/26.
//

/// 사용자가 읽고 싶은 책 데이터 생성 시 읽고 싶은 이유를 입력하지 않은 경우를 대비한 기본 문구 제공 유틸입니다.
///
/// - Note:
///   - `reason`이 공백인 경우, 이 리스트 중 하나가 랜덤으로 선택됩니다.
enum ReasonProvider {
  static let fallbackReasons: [String] = [
    "아무 이유 없이 떠나도 괜찮아요",
    "이 여행, 그냥 끌리지 않나요?",
    "이 여행의 이야기를 만나보세요",
    "가끔은 이유 없이도 충분해요",
    "어떤 이야기가 기다리고 있을까요?",
    "그냥 가고 싶다면, 그걸로 충분해요",
    "아무 생각 없이 떠나는 날도 필요하니까요",
    "이유가 없어도, 이 여행은 의미가 될 거예요",
    "떠나자!"
  ]

  /// fallback 문구 중 하나를 랜덤으로 반환합니다.
  static func random() -> String {
    fallbackReasons.randomElement() ?? ""
  }
}
