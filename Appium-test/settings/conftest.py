from appium.webdriver.common.appiumby import AppiumBy
from helpers.navigate_helper import navigate_to_tab

import time
import pytest

@pytest.fixture
def settings_screen(driver):
    navigate_to_tab(
        driver,
        "settings"
    )

    yield driver