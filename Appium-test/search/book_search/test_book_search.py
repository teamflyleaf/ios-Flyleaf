from appium.webdriver.common.appiumby import AppiumBy
from book_search_helper import *

import time
import pytest

# TC_SEARCH_001
# 자동 포커스 테스트
def test_searchbar_focus(book_search_screen):
    keyboard = book_search_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "UIKeyboardLayoutStar Preview"
    )
    assert keyboard is not None

# TC_SEARCH_002
# 검색바 전체 지우기 테스트
def test_searchbar_delete(book_search_screen, search_keywords):
    searchbar = book_search_screen.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypeTextField"
    )

    searchbar.send_keys(search_keywords[0])
    time.sleep(1)

    delete_button = book_search_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "텍스트 지우기"
    )
    delete_button.click()
    time.sleep(1)

    value = searchbar.get_attribute("value")
    placeholder = searchbar.get_attribute("placeholderValue")

    assert value == placeholder

# TC_SEARCH_003
# 검색 결과 없음 테스트
@pytest.mark.smoke
def test_search_result(book_search_screen, search_keywords):
    searchbar = helper_book_search_flow(book_search_screen, search_keywords[1])

    value = searchbar.get_attribute("value")

    element = book_search_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        f"'{value}' 관련 결과 0개"
    )

    assert element is not None

# TC_SEARCH_004
# 검색 결과 있음 테스트
@pytest.mark.smoke
def test_search_result_none(book_search_screen, search_keywords):
    searchbar = helper_book_search_flow(book_search_screen, search_keywords[0])

    value = searchbar.get_attribute("value")

    element = book_search_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        f'''label CONTAINS "'{value}' 관련 결과"'''
    )

    assert element is not None

