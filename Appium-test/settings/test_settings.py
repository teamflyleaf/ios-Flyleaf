from appium.webdriver.common.appiumby import AppiumBy
from selenium.common.exceptions import NoSuchElementException

import pytest
import time
import re

# 백버튼이 잘 눌리는지
def test_settings_header_back_button_tapped(settings_screen):
    back_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "chevron left"
    )

    back_button.click()
    time.sleep(2)

    home_element = settings_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        'label CONTAINS "의 여행 진행 중"'
    )

    assert home_element is not None

# TC_SETTINGS_001
# 소셜 계정 라벨이 존재하는지
@pytest.mark.smoke
@pytest.mark.regression
def test_settings_social_account_label(settings_screen):
    social_account_label = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "소셜 계정"
    )

    assert social_account_label is not None

# TC_SETTINGS_001
# 이메일 라벨 검증
@pytest.mark.smoke
@pytest.mark.regression
def test_settings_user_email(settings_screen):
    email = settings_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        'name CONTAINS "@"'
    )

    email_text = email.get_attribute("name")

    email_pattern = r'^[A-Za-z0-9._+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    assert re.match(email_pattern, email_text)

# TC_SETTINGS_002
# 로그아웃 버튼이 존재하는지
@pytest.mark.smoke
def test_settings_logout_button(settings_screen):
    logout_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "로그아웃"
    )

    assert logout_button is not None

# TC_SETTINGS_002
# 로그아웃 버튼 클릭 테스트
@pytest.mark.skip(reason="로그아웃 후 로그인 상태가 복구되지 않음 - 테스트 전용 계정/진입점 필요")
def test_settings_logount_button_tapped(settings_screen):
    logout_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "로그아웃"
    )

    logout_button.click()
    time.sleep(2)

    login_page_elements = ["독서 여행을 떠나볼까요?", "독서 여행 기록을 저장하고"]

    for e in login_page_elements:
        element = settings_screen.find_element(
            AppiumBy.IOS_PREDICATE,
            f'label CONTAINS "{e}"'
        )
        assert element is not None

# TC_SETTINGS_003
# 회원 탈퇴 버튼이 존재하는지
@pytest.mark.regression
def test_settings_deleteAccount_button(settings_screen):
    deleteAccount_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "회원탈퇴"
    )
    assert deleteAccount_button is not None

# TC_SETTINGS_004
# 회원 탈퇴 버튼 테스팅
def test_settings_deleteAccount_button_tapped(settings_screen):
    deleteAccount_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "회원탈퇴"
    )

    deleteAccount_button.click()
    time.sleep(2)

    deleteAccount_modal_elements = [
        "회원탈퇴", 
        "탈퇴하면 모든 데이터가 삭제되며 복구할 수 없어요. 정말 탈퇴하시겠어요?"
        ]

    for e in deleteAccount_modal_elements:
        element = settings_screen.find_element(
            AppiumBy.ACCESSIBILITY_ID,
            e
        )
        assert element is not None

# TC_SETTINGS_005
# 회원 탈퇴 모달의 취소 버튼 테스팅
@pytest.mark.regression
def test_settings_deleteAccount_modal_cancel_button_tapped(settings_screen):
    deleteAccount_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "회원탈퇴"
    )

    deleteAccount_button.click()
    time.sleep(2)

    deleteAccount_modal_cancel_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "취소"
    )

    deleteAccount_modal_cancel_button.click()
    time.sleep(2)

    try:
        element = settings_screen.find_element(
            AppiumBy.IOS_CLASS_CHAIN,
            '**/XCUIElementTypeStaticText[`name == "회원탈퇴"`][2]'
        )
        assert False
    except NoSuchElementException:
        pass

# 설정 라벨이 존재하는지
@pytest.mark.regression
def test_settings_setting_label(settings_screen):
    setting_label = settings_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "설정"`][2]'
    )
    assert setting_label is not None

# TC_SETTINGS_006
# 시스템 테마 설정 버튼이 존재하는지
def test_settings_system_theme_button(settings_screen):
    system_theme_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "시스템 테마 설정"
    )
    assert system_theme_button is not None

# TC_SETTINGS_006
# 시스템 테마 설정 클릭 테스트
def test_settings_system_theme_button_tapped(settings_screen):
    system_theme_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "시스템 테마 설정"
    )

    system_theme_button.click()
    time.sleep(2)

    system_theme_header_title = settings_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "시스템 테마 설정"`]'
    )
    assert system_theme_header_title is not None

# 앱 버전 라벨이 존재하는지
@pytest.mark.regression
def test_settings_appversion_label(settings_screen):
    appversion_label = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "앱 버전"
    )
    assert appversion_label is not None

# TC_SETTINGS_010
# 개인정보 처리방침 버튼이 존재하는지
@pytest.mark.regression
def test_settings_privacy_policy_button(settings_screen):
    privacy_policy_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "개인정보 처리방침"
    )
    assert privacy_policy_button is not None

# TC_SETTINGS_010
# 개인정보 처리방침 클릭 테스트
@pytest.mark.regression
def test_settings_privacy_policy_button_tapped(settings_screen):
    privacy_policy_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "개인정보 처리방침"
    )

    privacy_policy_button.click()
    time.sleep(2)

    privacy_policy_header_title = settings_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "개인정보 처리방침"`]'
    )
    assert privacy_policy_header_title is not None

# TC_SETTINGS_011
# 서비스 이용약관 버튼이 존재하는지
@pytest.mark.regression
def test_settings_termsOfService_button(settings_screen):
    termsOfService_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "서비스 이용약관"
    )
    assert termsOfService_button is not None

# TC_SETTINGS_011
# 서비스 이용약관 버튼 클릭 테스트
@pytest.mark.regression
def test_settings_termsOfService_button_tapped(settings_screen):
    termsOfService_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "서비스 이용약관"
    )

    termsOfService_button.click()
    time.sleep(2)

    termsOfService_header_title = settings_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "서비스 이용약관"`]'
    )
    assert termsOfService_header_title is not None

# TC_SETTINGS_012
# 오픈 소스 버튼이 존재하는지
@pytest.mark.regression
def test_settings_opensource_button(settings_screen):
    opensource_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "오픈 소스"
    )
    assert opensource_button is not None

# TC_SETTINGS_012
# 오픈 소스 버튼 클릭 테스트
@pytest.mark.regression
def test_settings_opensource_button_tapped(settings_screen):
    opensource_button = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "오픈 소스"
    )

    opensource_button.click()
    time.sleep(2)

    opensource_header_title = settings_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "오픈 소스"`]'
    )
    assert opensource_header_title is not None

# 리포트 라벨이 존재하는지
@pytest.mark.regression
def test_report_label(settings_screen):
    report_label = settings_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "리포트"
    )
    assert report_label is not None