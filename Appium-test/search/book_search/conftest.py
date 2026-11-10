from appium.webdriver.common.appiumby import AppiumBy
from helpers.navigate_helper import navigate_to_tab

import time
import pytest

# 책 검색화면 드라이버 세팅
@pytest.fixture
def book_search_screen(driver):
    navigate_to_tab(
        driver,
        "plus"
    )

    navigate_to_tab(
        driver,
        "다 읽은 책"
    )

    tab = driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        "**/XCUIElementTypeWindow/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[4]/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeButton"
    )
    tab.click()
    time.sleep(2)

    yield driver


