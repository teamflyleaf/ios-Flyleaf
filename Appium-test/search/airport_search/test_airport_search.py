from appium.webdriver.common.appiumby import AppiumBy
from airport_search_helper import *

import time
import pytest

# TC_AIRPORT_SEARCH_001
# 자동 포커스 테스트
def test_searchbar_focus(airport_search_screen):
    keyboard = airport_search_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "UIKeyboardLayoutStar Preview"
    )
    assert keyboard is not None

# TC_AIRPORT_SEARCH_002
# 검색바 전체 지우기 테스트
def test_searchbar_delete(airport_search_screen, airports_normal):
    searchbar = airport_search_screen.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypeTextField"
    )

    searchbar.send_keys(airports_normal[0])
    time.sleep(1)

    delete_button = airport_search_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "텍스트 지우기"
    )
    delete_button.click()
    time.sleep(1)

    value = searchbar.get_attribute("value")
    placeholder = searchbar.get_attribute("placeholderValue")

    assert value == placeholder

# TC_AIRPORT_SEARCH_003
# 검색 결과 없음 테스트
@pytest.mark.smoke
def test_search_result(airport_search_screen, airports_normal):
    searchbar = helper_airport_search_flow(airport_search_screen, airports_normal[2])

    value = searchbar.get_attribute("value")

    element = airport_search_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        f"'{value}' 관련 결과 0개"
    )

    assert element is not None

# TC_AIRPORT_SEARCH_004
# 검색 결과 있음 테스트
@pytest.mark.smoke
def test_search_result_none(airport_search_screen, airports_normal):
    searchbar = helper_airport_search_flow(airport_search_screen, airports_normal[0])

    value = searchbar.get_attribute("value")

    element = airport_search_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        f'''label CONTAINS "'{value}' 관련 결과"'''
    )

    assert element is not None

