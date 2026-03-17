//
//  ReadingJourneyStatusType.swift
//  Core
//
//  Created by 여성일 on 3/10/26.
//

/// 독서 여행의 진행 상태를 나타내는 타입입니다.
///
/// 사용자가 설정한 독서 여행이 현재 어떤 상태인지 구분하기 위해 사용됩니다.
///
/// - `wishlist`: 읽고 싶은 책 상태
/// - `reading`: 현재 읽고 있는 상태
/// - `finished`: 독서를 완료한 상태
public enum ReadingJourneyStatusType: String, Codable, Sendable {
  /// 읽고 싶은 책
  case wishlist
  /// 읽고 있는 책
  case reading
  /// 다 읽은 책
  case finished
}
