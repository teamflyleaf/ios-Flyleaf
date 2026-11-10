from appium.webdriver.common.appiumby import AppiumBy
from helpers.navigate_helper import *

import time
import re
import pytest

# TC_HOME_001
# 홈화면 그리팅 텍스트 UI 테스트
@pytest.mark.smoke
def test_home_greeting_title(driver):
    navigate_to_home_tab(driver)
    greeting = driver.find_element(
        AppiumBy.IOS_PREDICATE,
        'label CONTAINS "좋은" OR label CONTAINS "편안한"'
    )

    greeting_text = greeting.get_attribute("label")

    valid_greetings = [
        "좋은 아침이에요",
        "좋은 오후에요",
        "좋은 저녁이에요",
        "편안한 밤이에요"
    ]

    assert any(valid in greeting_text for valid in valid_greetings)

# TC_HOME_001
# 홈화면 여행 상태 텍스트 UI 테스트
@pytest.mark.smoke
def test_home_journey_state(driver):
    navigate_to_home_tab(driver)
    journey_state = driver.find_element(
        AppiumBy.IOS_PREDICATE,
        'label CONTAINS "의 여행 진행 중"'
    )

    assert journey_state is not None

# TC_HOME_001
# 홈화면 여행 거리 상태 텍스트 UI 테스트
@pytest.mark.smoke
def test_home_journey_distance(driver):
    navigate_to_home_tab(driver)
    journey_distance = driver.find_element(
        AppiumBy.IOS_PREDICATE,
        'label CONTAINS "km 여행"'
    )

    journey_distance_text = journey_distance.get_attribute("label")

    pattern = r'총 [\d,]+ km 여행'
    assert re.fullmatch(pattern, journey_distance_text)

#  TC_HOME_012
# 홈화면 설정 버튼 클릭 테스트
def test_home_setting_button_tapped_navigate_to_settings(driver):
    navigate_to_home_tab(driver)
    setting_button = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "settings"
    )

    setting_button.click()
    time.sleep(2)

    setting_header_title = driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "설정"`][1]'
    )
    assert setting_header_title is not None

# TC_HOME_007
# 홈화면 플로팅 버튼 클릭 시 드롭다운 메뉴 정상 출력 테스트
def test_home_fab_button_tapped_allSatisfy_menu(driver):
    fab_button = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "plus"
    )

    fab_button.click()
    time.sleep(2)

    menus = ["다 읽은 책", "읽고 있는 책", "읽고 싶은 책"]

    for menu in menus:
        menu_title = driver.find_element(
            AppiumBy.ACCESSIBILITY_ID,
            menu
        )
        assert menu_title is not None, f"{menu} 메뉴가 없습니다."

    