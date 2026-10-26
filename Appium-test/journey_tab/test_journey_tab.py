from appium.webdriver.common.appiumby import AppiumBy

from enums.JourneySegment import JourneySegment
from helpers.picker_helper import (
    helper_get_picker_wheel,
    helper_move_picker_to_page,
    helper_parse_wheel_value,
)
from journey_tab.journey_tab_helper import (
    helper_find_delete_alert_message,
    helper_long_press_first_journey,
    helper_open_memo_write_sheet,
    helper_tap_add_journey_button,
    helper_tap_delete_journey_button,
    helper_tap_segment,
)

import time
import pytest

BOOK_INFO_TITLES = ["책소개", "출판사", "페이지", "ISBN13"]
JOURNEY_INFO_TITLES = ["시작일", "읽은 페이지 수", "여행 거리", "남은 거리"]

# 해당 타이틀 라벨이 화면에 존재하는지
def is_title_present(driver, title):
    return len(driver.find_elements(AppiumBy.ACCESSIBILITY_ID, title)) > 0

# 여행 탭의 읽은 페이지 라벨(ex. "2p") 반환
def find_current_page_label(driver):
    return driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name MATCHES "[0-9]+p"`]'
    )

# 메모 작성 시트의 페이지 선택 버튼 (선택 전에는 placeholder "0 / 전체페이지")
def find_memo_page_button(driver):
    return driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value MATCHES "[0-9]+ / [0-9]+"`]'
    )

# 메모 작성 시트의 저장 버튼
def find_memo_save_button(driver):
    return driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "저장"`]'
    )

# TC_JOURNEY_TAB_002
# 원형 버튼 롱프레스 텟스트
def test_journey_tab_circle_button_long_press_shows_delete_alert(journey_tab_with_data):
    helper_long_press_first_journey(journey_tab_with_data)

    assert len(helper_find_delete_alert_message(journey_tab_with_data)) > 0

# TC_JOURNEY_TAB_003
# 책정보 탭 버튼 테스트 - 클릭
def test_journey_tab_book_info_button_tapped(journey_tab_with_data):
    helper_tap_segment(journey_tab_with_data, JourneySegment.BOOK)

    for title in BOOK_INFO_TITLES:
        assert is_title_present(journey_tab_with_data, title), f"책정보 UI 누락: {title}"

    # 다른 탭의 UI는 출력되지 않아야 함
    assert not is_title_present(journey_tab_with_data, "읽은 페이지 수")

# TC_JOURNEY_TAB_004
# 여행 탭 버튼 테스트 - 클릭
@pytest.mark.smoke
def test_journey_tab_journey_info_button_tapped(journey_tab_with_data):
    helper_tap_segment(journey_tab_with_data, JourneySegment.JOURNEY)

    for title in JOURNEY_INFO_TITLES:
        assert is_title_present(journey_tab_with_data, title), f"여행 정보 UI 누락: {title}"

    assert not is_title_present(journey_tab_with_data, "책소개")

# TC_JOURNEY_TAB_005
# 여행 탭 버튼 테스트 - 읽은 페이지 수 수정
def test_journey_tab_current_page_label_tapped_shows_picker(journey_tab_with_data):
    helper_tap_segment(journey_tab_with_data, JourneySegment.JOURNEY)

    find_current_page_label(journey_tab_with_data).click()
    time.sleep(1)

    pickers = journey_tab_with_data.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )
    assert len(pickers) > 0

# TC_JOURNEY_TAB_006
# 읽은 페이지 수 픽커 테스트 선택 값 (현재 읽은 페이지가 기본 선택)
def test_journey_tab_current_page_picker_default_value(journey_tab_with_data):
    helper_tap_segment(journey_tab_with_data, JourneySegment.JOURNEY)

    label_page = int(find_current_page_label(journey_tab_with_data).get_attribute("name")[:-1])

    find_current_page_label(journey_tab_with_data).click()
    time.sleep(1)

    wheel_page, total_pages = helper_parse_wheel_value(helper_get_picker_wheel(journey_tab_with_data))
    assert wheel_page == label_page

# TC_JOURNEY_TAB_008
# 메모 탭 버튼 테스트 - 클릭
@pytest.mark.smoke
def test_journey_tab_memo_button_tapped(journey_tab_with_data):
    helper_tap_segment(journey_tab_with_data, JourneySegment.MEMO)

    memo_count = journey_tab_with_data.find_elements(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name BEGINSWITH "메모("`]'
    )
    assert len(memo_count) > 0

    journey_tab_with_data.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "메모작성"
    )

    assert not is_title_present(journey_tab_with_data, "책소개")

# TC_JOURNEY_TAB_010
# 메모 탭 버튼 - 메모 작성 버튼
def test_journey_tab_memo_write_button_tapped_shows_sheet(journey_tab_with_data):
    helper_open_memo_write_sheet(journey_tab_with_data)

    for title in ["메모 작성", "페이지", "내용"]:
        assert is_title_present(journey_tab_with_data, title), f"메모 작성 시트 UI 누락: {title}"

    find_memo_save_button(journey_tab_with_data)

# TC_JOURNEY_TAB_011
# 메모 작성 시트 - 페이지 선택 버튼 클릭
def test_journey_tab_memo_page_button_tapped_shows_picker(journey_tab_with_data):
    helper_open_memo_write_sheet(journey_tab_with_data)

    find_memo_page_button(journey_tab_with_data).click()
    time.sleep(1)

    pickers = journey_tab_with_data.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )
    assert len(pickers) > 0

# TC_JOURNEY_TAB_012
# 메모 작성 시트 - 페이지 선택 완료 
def test_journey_tab_memo_page_select(journey_tab_with_data):
    helper_open_memo_write_sheet(journey_tab_with_data)

    find_memo_page_button(journey_tab_with_data).click()
    time.sleep(1)

    total_pages = helper_move_picker_to_page(journey_tab_with_data, 3)

    journey_tab_with_data.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "완료"
    ).click()
    time.sleep(1)

    journey_tab_with_data.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeTextField[`value == "3 / {total_pages}"`]'
    )

    pickers = journey_tab_with_data.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )
    assert len(pickers) == 0

# TC_JOURNEY_TAB_013
# 메모 작성 시트 저장 버튼 비활성화 
def test_journey_tab_memo_save_button_disabled_when_content_empty(journey_tab_with_data):
    helper_open_memo_write_sheet(journey_tab_with_data)

    assert not find_memo_save_button(journey_tab_with_data).is_enabled()

# TC_JOURNEY_TAB_014
# 메모 작성 시트 저장 버튼 활성화 
def test_journey_tab_memo_save_button_enabled_when_content_entered(journey_tab_with_data):
    helper_open_memo_write_sheet(journey_tab_with_data)

    journey_tab_with_data.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypeTextView"
    ).send_keys("자동화 테스트 메모")
    time.sleep(1)

    assert find_memo_save_button(journey_tab_with_data).is_enabled()

# TC_JOURNEY_TAB_017
# 여행 삭제 버튼 클릭 
def test_journey_tab_delete_button_tapped_shows_alert(journey_tab_with_data):
    helper_tap_delete_journey_button(journey_tab_with_data)

    assert len(helper_find_delete_alert_message(journey_tab_with_data)) > 0

    for title in ["취소", "삭제"]:
        journey_tab_with_data.find_element(
            AppiumBy.IOS_CLASS_CHAIN,
            f'**/XCUIElementTypeAlert/**/XCUIElementTypeButton[`name == "{title}"`]'
        )

# TC_JOURNEY_TAB_018
# 여행 삭제 버튼 클릭 취소 
def test_journey_tab_delete_alert_cancel(journey_tab_with_data):
    helper_tap_delete_journey_button(journey_tab_with_data)

    assert len(helper_find_delete_alert_message(journey_tab_with_data)) > 0

    journey_tab_with_data.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeAlert/**/XCUIElementTypeButton[`name == "취소"`]'
    ).click()
    time.sleep(1)

    assert len(helper_find_delete_alert_message(journey_tab_with_data)) == 0

# TC_JOURNEY_TAB_020
# 여행 추가 버튼 클릭 
@pytest.mark.smoke
def test_journey_tab_add_button_tapped_navigate_to_add_journey(journey_tab_screen):
    helper_tap_add_journey_button(journey_tab_screen)

    journey_tab_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "이미 시작한 여행이 있나요?"
    )
