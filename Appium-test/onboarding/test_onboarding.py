from appium.webdriver.common.appiumby import AppiumBy
import pytest
import time

# 로그아웃 상태에서만 실행 가능 (기본 실행 제외)
pytestmark = pytest.mark.logged_out

# 헬퍼 함수
def start_button_find(driver):
    return driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "시작하기"
    )

# TC_ONB_001
# 앱 실행 후 애니메이션 출력 및 전환 테스트
def test_onboarding_auto_transition(driver):
    time.sleep(5)
    time.sleep(20)

# TC_ONB_006
# 시작하기 버튼이 존재 하는지 검증하는 테스트
def test_onboarding_start_button(driver):
    start_button = start_button_find(driver)
    assert start_button is not None

# TC_ONB_006
# 시작하기 버튼 클릭 후 로그인 화면으로 잘 전환 되는지 확인하는 테스트
def test_onboarding_start_button_tapped(driver):
    start_button = start_button_find(driver)
    start_button.click()
    time.sleep(3)

    login_element = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "독서 여행을 떠나볼까요?"
    )
    assert login_element is not None
