from appium.webdriver.common.appiumby import AppiumBy
from helpers.register_flow_helper import (
    helper_search_and_select_book,
    helper_select_airport,
    helper_select_date,
)
from enums.Airport import Airport
from enums.DateField import DateField

import time

# 책 선택 -> 시작일/종료일 선택 -> 다음 버튼 클릭 (경로 선택 단계로 이동)
def helper_navigate_to_route_step(driver, keyword):
    helper_search_and_select_book(driver, keyword)
    helper_select_date(driver, DateField.START)
    helper_select_date(driver, DateField.END)

    next_button = driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    next_button.click()
    time.sleep(1)

# 출발지/도착지 선택 -> 다음 버튼 클릭 (최종 확인 단계로 이동)
def helper_navigate_to_check(driver, airport):
    helper_select_airport(driver, airport[0], Airport.DEPARTURE)
    helper_select_airport(driver, airport[1], Airport.DESTINATION)

    button = driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    button.click()
    time.sleep(1)
