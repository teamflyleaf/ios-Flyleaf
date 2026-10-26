from appium.webdriver.common.appiumby import AppiumBy
from helpers.tab_helper import (
    helper_element_y,
    helper_first_table_cell,
    helper_scroll_until_visible,
)

import time

# 기록이 없을 때 출력되는 라벨
EMPTY_HISTORY_TITLE = "아직 기록이 없어요"

# 날짜 필드 값 형식
DATE_VALUE_PATTERN = "[0-9]{4}\\\\.[0-9]{2}\\\\.[0-9]{2}"

# 기록이 한 개 이상 존재하는지 확인한다.
def helper_has_history(driver):
    return len(driver.find_elements(AppiumBy.ACCESSIBILITY_ID, EMPTY_HISTORY_TITLE)) == 0

# 첫 번째 티켓 클릭 -> 기록 상세 페이지 진입
def helper_open_first_history_detail(driver):
    helper_first_table_cell(driver).click()
    time.sleep(1)

# 상세 페이지의 날짜 필드 두 개를 위에서부터 [시작일, 종료일] 순서로 반환
def helper_find_date_fields(driver):
    fields = driver.find_elements(
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeTextField[`value MATCHES "{DATE_VALUE_PATTERN}"`]'
    )
    assert len(fields) == 2, f"날짜 필드가 2개가 아닙니다. ({len(fields)}개)"

    return sorted(fields, key=helper_element_y)

# 감상평 영역 클릭 (감상평 섹션 타이틀 바로 아래 라벨. 스크롤이 필요해서 타이틀이 보일 때까지 내린다)
def helper_tap_review_area(driver):
    title = helper_scroll_until_visible(driver, "감상평")
    title_y = title.rect["y"]

    labels = driver.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypeStaticText"
    )
    below = [label for label in labels if label.rect["y"] > title_y]
    assert len(below) > 0, "감상평 영역을 찾지 못했습니다."

    min(below, key=helper_element_y).click()
    time.sleep(1)
