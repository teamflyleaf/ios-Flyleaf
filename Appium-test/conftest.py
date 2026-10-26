import time

import pytest
from appium import webdriver
from appium.options.ios import XCUITestOptions
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

from helpers.navigate_helper import *

BUNDLE_ID = "com.yeo.flyleaf"
APP_LAUNCH_TIMEOUT = 30
# XCUITest query_app_state 결과값: 4 = 포그라운드에서 실행 중
APP_STATE_RUNNING_FOREGROUND = 4


# 드라이버 세팅 (세션은 전체 테스트에서 1회만 생성)
@pytest.fixture(scope="session")
def driver():
    options = XCUITestOptions()
    options.device_name = "iPhone 17"
    options.platform_version = "26.5"
    options.automation_name = "XCUITest"
    options.bundle_id = BUNDLE_ID
    # 앱 데이터(로그인 정보 등)는 유지
    options.no_reset = True
    # noReset=True 이면 기본값이 false 가 되므로 명시적으로 지정
    # (세션 시작 시 앱 재시작 / 세션 종료 시 앱 종료)
    options.set_capability("appium:forceAppLaunch", True)
    options.set_capability("appium:shouldTerminateApp", True)

    print("Flyleaf 앱을 실행 중 입니다.")
    drv = webdriver.Remote(
        "http://127.0.0.1:4723",
        options=options
    )
    print("Appium 세션 생성 완료")

    yield drv

    drv.quit()
    print("Appium 세션 종료 (앱 종료)")


# 앱이 포그라운드에서 실행 중인지 확인 (WebDriverWait 조건 함수)
def is_app_running_foreground(driver):
    return driver.query_app_state(BUNDLE_ID) == APP_STATE_RUNNING_FOREGROUND


# 테스트마다 앱 재시작 (모든 테스트에 자동 적용)
# logged_out 마커 테스트: 로그아웃 상태에서 실행해야 하므로 홈 탭 대기 없이 런치 대기만 한다.
# 그 외 테스트: 홈 탭이 나타날 때까지 대기한다.
@pytest.fixture(autouse=True)
def fresh_app(request, driver):
    driver.terminate_app(BUNDLE_ID)
    driver.activate_app(BUNDLE_ID)

    WebDriverWait(driver, APP_LAUNCH_TIMEOUT).until(is_app_running_foreground)

    if request.node.get_closest_marker("logged_out"):
        time.sleep(3)
    else:
        WebDriverWait(driver, APP_LAUNCH_TIMEOUT).until(
            EC.presence_of_element_located((AppiumBy.ACCESSIBILITY_ID, "홈"))
        )

    yield

# 책 검색 mock 데이터
@pytest.fixture
def search_keywords():
    return [
        "설국",
        "ㅁㄴ이;ㅁ나ㅣ엄ㄴ"
    ]

@pytest.fixture
def review_normal():
    return "가" * 5

@pytest.fixture
def review_over_limit():
    return "가" * 101

@pytest.fixture
def airports_normal():
    return [
        "청주",
        "리버풀",
        "asdkwoelsdlkfl"
    ]

