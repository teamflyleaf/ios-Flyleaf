from appium.webdriver.common.appiumby import AppiumBy
from helpers.navigate_helper import *

import time
import pytest

# 읽고 싶은 책 등록 화면 진입
@pytest.fixture
def add_wish_screen(driver):
    navigate_to_tab(
        driver,
        "plus"
    )

    navigate_to_tab(
        driver,
        "읽고 싶은 책"
    )

    yield driver