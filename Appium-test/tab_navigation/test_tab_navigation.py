from appium.webdriver.common.appiumby import AppiumBy
from helpers.navigate_helper import *

import time
import pytest

# 탭 존재 유무 테스트
@pytest.mark.smoke
def test_all_tabs_exist(driver):
    tabs = ["홈", "여행", "예약", "기록"]

    for tab_name in tabs:
        tab = driver.find_element(AppiumBy.ACCESSIBILITY_ID, tab_name)
        assert tab is not None, f"{tab_name} 탭이 존재하지 않습니다."
        print(f"{tab_name} 탭은 존재합니다.")

    print("탭 존재 확인 완료")

# 홈 탭 이동 테스트
@pytest.mark.smoke
def test_navigation_to_home_tab(driver):
    navigate_to_home_tab(driver)
    print("홈 탭 이동 완료")

# 저니 탭 이동 테스트
@pytest.mark.smoke
def test_navigation_to_journey_tab(driver):
    navigate_to_journey_tab(driver)
    print("여행 탭 이동 완료")

# 위시리스트 이동 테스트
@pytest.mark.smoke
def test_navigation_to_wishlist_tab(driver):
    navigate_to_wishlist_tab(driver)
    print("예약 탭 이동 완료")

# 기록 탭 이동 테스트
@pytest.mark.smoke
def test_navigation_to_history_tab(driver):
    navigate_to_history_tab(driver)
    print("기록 탭 이동 완료")

# 탭 전체 이동 사이클 테스트
@pytest.mark.smoke
def test_tab_navigation_full_cycle(driver):
    tabs = ["홈", "여행", "예약", "기록", "홈"]

    for tab_name in tabs:
        navigate_to_tab(
            driver,
            tab_name
        )
        print(f"{tab_name} 클릭")
    print("전체 탭 순환 테스트 완료")