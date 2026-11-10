from appium.webdriver.common.appiumby import AppiumBy
from helpers.tab_helper import helper_first_table_cell

import time

# 예약이 없을 때 출력되는 라벨
EMPTY_WISH_TITLE = "아직 예약이 없어요"
SWIPE_DISTANCE_RATIO = 0.7

# 예약이 한 개 이상 존재하는지 확인한다. (전제 조건 확인용)
def helper_has_wish(driver):
    return len(driver.find_elements(AppiumBy.ACCESSIBILITY_ID, EMPTY_WISH_TITLE)) == 0

# 첫 번째 예약 티켓을 좌 -> 우 방향으로 스와이프
def helper_swipe_first_wish_ticket(driver):
    rect = helper_first_table_cell(driver).rect

    start_x = rect["x"] + rect["width"] * 0.1
    end_x = start_x + rect["width"] * SWIPE_DISTANCE_RATIO
    y = rect["y"] + rect["height"] / 2

    driver.execute_script("mobile: dragFromToForDuration", {
        "duration": 0.5,
        "fromX": start_x,
        "fromY": y,
        "toX": end_x,
        "toY": y
    })
    time.sleep(1)
