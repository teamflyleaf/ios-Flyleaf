from appium.webdriver.common.appiumby import AppiumBy
from helpers.navigate_helper import navigate_to_tab
from add_history.add_history_helper import helper_navigate_to_route_step

import time
import pytest

# 출발 공항 검색 화면 진입
# 등록 플로우(책 선택 -> 날짜 선택 -> 다음)로 경로 선택 단계까지 이동한 뒤 출발지 버튼을 누른다.
@pytest.fixture
def airport_search_screen(driver, search_keywords):
    # 다 읽은 책 등록 화면 진입 (플로팅 버튼 -> 다 읽은 책)
    navigate_to_tab(
        driver,
        "plus"
    )

    navigate_to_tab(
        driver,
        "다 읽은 책"
    )

    helper_navigate_to_route_step(driver, search_keywords[0])

    driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "버튼을 눌러 출발지를 등록하세요"
    ).click()
    time.sleep(1)

    yield driver
