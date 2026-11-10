from appium.webdriver.common.appiumby import AppiumBy
import pytest
import time

# 로그아웃 상태에서만 실행 가능 (기본 실행 제외)
pytestmark = pytest.mark.logged_out

# TC_LOGIN_001
# 로그인 타이틀 존재 확인
def test_login_title(driver):
    titleLabel = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "독서 여행을 떠나볼까요?"
    )
    assert titleLabel is not None
    print("타이틀은 존재합니다.")

# TC_LOGIN_001
# 로그인 서브 타이틀 존재 확인
def test_login_subTitle(driver):
    subtitleLabel = driver.find_element(
        AppiumBy.IOS_PREDICATE,
        'label CONTAINS "독서 여행 기록을 저장하고" AND label CONTAINS "언제든 이어서 읽을 수 있어요"'
    )
    assert subtitleLabel is not None
    print("서브 타이틀은 존재합니다.")

# TC_LOGIN_001
# 애플 로그인 버튼 존재 확인
def test_login_appleLogin(driver):
    appleLoginButton = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "Apple로 로그인"
    )
    assert appleLoginButton is not None
    print("애플 로그인 버튼은 존재합니다.")
    
# TC_LOGIN_003
# 애플 로그인 취소 테스트
def test_login_appleLogin_close_tapped(driver):
    appleLoginButton = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "Apple로 로그인"
    )
    appleLoginButton.click()
    time.sleep(2)

    driver.tap([(358, 574)])
    time.sleep(2)