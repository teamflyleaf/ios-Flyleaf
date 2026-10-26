from enum import Enum

# 여행 탭의 세그먼트 칩 버튼 (왼쪽 -> 오른쪽 순서, value = 순서 인덱스)
class JourneySegment(Enum):
    BOOK = 0       # 책정보
    JOURNEY = 1    # 여행
    MEMO = 2       # 메모
