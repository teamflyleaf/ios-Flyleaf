from appium.webdriver.common.appiumby import AppiumBy
from enums.JourneySegment import JourneySegment
from helpers.tab_helper import (
    helper_element_x,
    helper_element_y,
)

import time

SEGMENT_CHIP_HEIGHT = 36
DELETE_JOURNEY_MESSAGE = "이 여행을 삭제할까요?"
EMPTY_JOURNEY_TITLE = "진행 중인 여행이 없어요"

def helper_has_journey(driver):
    empty = driver.find_elements(
        AppiumBy.ACCESSIBILITY_ID,
        EMPTY_JOURNEY_TITLE
    )
    return len(empty) == 0

def helper_tap_add_journey_button(driver):
    buttons = driver.find_elements(
        AppiumBy.ACCESSIBILITY_ID,
        "plus"
    )
    assert len(buttons) > 0, "여행 탭의 + 버튼을 찾지 못했습니다."

    top_button = min(buttons, key=helper_element_y)
    top_button.click()
    time.sleep(1)

# 여행 삭제(휴지통) 버튼 클릭 (이미지 에셋 이름 "trash")
def helper_tap_delete_journey_button(driver):
    driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "trash"
    ).click()
    time.sleep(1)

# 세그먼트 칩 버튼(책정보/여행/메모) 클릭
# 칩 버튼은 아이콘만 있는 라벨 없는 버튼이라, 높이 36 인 버튼 중
# 가장 위쪽 줄에 있는 것들을 x 좌표 순서로 정렬해 선택한다.
def helper_tap_segment(driver, segment: JourneySegment):
    buttons = driver.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypeButton"
    )

    chips = [b for b in buttons if round(b.rect["height"]) == SEGMENT_CHIP_HEIGHT]
    assert len(chips) >= len(JourneySegment), \
        f"세그먼트 칩 버튼을 찾지 못했습니다. (높이 {SEGMENT_CHIP_HEIGHT} 버튼 {len(chips)}개)"

    first_row_y = min(chip.rect["y"] for chip in chips)
    row = sorted(
        [chip for chip in chips if abs(chip.rect["y"] - first_row_y) < 2],
        key=helper_element_x
    )
    assert len(row) == len(JourneySegment), \
        f"세그먼트 칩 버튼이 {len(JourneySegment)}개가 아닙니다. ({len(row)}개)"

    row[segment.value].click()
    time.sleep(1)

# 메모 탭으로 이동 -> '메모작성' 버튼 클릭
def helper_open_memo_write_sheet(driver):
    helper_tap_segment(driver, JourneySegment.MEMO)
    driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "메모작성"
    ).click()
    time.sleep(1)

# 첫 번째 여행 원형 버튼 롱프레스 헬퍼 함수
def helper_long_press_first_journey(driver, duration=1.5):
    cell = driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeCollectionView/XCUIElementTypeCell[1]'
    )
    driver.execute_script("mobile: touchAndHold", {
        "elementId": cell.id,
        "duration": duration
    })
    time.sleep(1)

# 삭제 알럿의 메시지가 출력 중인지 
def helper_find_delete_alert_message(driver):
    return driver.find_elements(
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeAlert/**/XCUIElementTypeStaticText[`name == "{DELETE_JOURNEY_MESSAGE}"`]'
    )
