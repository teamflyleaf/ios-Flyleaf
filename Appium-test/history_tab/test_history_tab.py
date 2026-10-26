from appium.webdriver.common.appiumby import AppiumBy

from helpers.tab_helper import (
    helper_find_alert_button,
    helper_find_delete_alert_message,
    helper_first_table_cell,
    helper_is_title_present,
    helper_long_press,
    helper_tap_top_plus_button,
)
from history_tab.history_tab_helper import (
    EMPTY_HISTORY_TITLE,
    helper_find_date_fields,
    helper_open_first_history_detail,
    helper_tap_review_area,
)

import time
import pytest

# TC_HISTORY_TAB_002
# 티켓 테스트 - 롱프레스
def test_history_tab_ticket_long_press_shows_delete_alert(history_tab_with_data):
    helper_long_press(history_tab_with_data, helper_first_table_cell(history_tab_with_data))

    assert len(helper_find_delete_alert_message(history_tab_with_data)) > 0

# TC_HISTORY_TAB_003
# 티켓 테스트 - 롱프레스 - 삭제 취소 (알럿이 닫힘)
def test_history_tab_ticket_long_press_cancel(history_tab_with_data):
    helper_long_press(history_tab_with_data, helper_first_table_cell(history_tab_with_data))
    assert len(helper_find_delete_alert_message(history_tab_with_data)) > 0

    helper_find_alert_button(history_tab_with_data, "취소").click()
    time.sleep(1)

    assert len(helper_find_delete_alert_message(history_tab_with_data)) == 0

# TC_HISTORY_TAB_005
# 티켓 테스트 - 클릭 (기록 상세 페이지로 이동)
@pytest.mark.smoke
def test_history_tab_ticket_tapped_navigate_to_detail(history_tab_with_data):
    helper_open_first_history_detail(history_tab_with_data)

    for title in ["시작일", "종료일", "감상평"]:
        assert helper_is_title_present(history_tab_with_data, title), f"기록 상세 UI 누락: {title}"

# TC_HISTORY_TAB_006
# 기록 상세페이지 - 시작일 수정 버튼 클릭 
def test_history_tab_start_date_button_tapped_shows_picker(history_tab_with_data):
    helper_open_first_history_detail(history_tab_with_data)

    helper_find_date_fields(history_tab_with_data)[0].click()
    time.sleep(1)

    wheels = history_tab_with_data.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePickerWheel"
    )
    assert len(wheels) > 0

# TC_HISTORY_TAB_010
# 기록 상세페이지 - 종료일 수정 버튼 클릭
def test_history_tab_finish_date_button_tapped_shows_picker(history_tab_with_data):
    helper_open_first_history_detail(history_tab_with_data)

    helper_find_date_fields(history_tab_with_data)[1].click()
    time.sleep(1)

    wheels = history_tab_with_data.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePickerWheel"
    )
    assert len(wheels) > 0

# TC_HISTORY_TAB_014
# 기록이 있을 때 UI 테스트 
@pytest.mark.smoke
def test_history_tab_default_ui_with_history(history_tab_with_data):
    tickets = history_tab_with_data.find_elements(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTable/XCUIElementTypeCell'
    )
    assert len(tickets) > 0

    assert not helper_is_title_present(history_tab_with_data, EMPTY_HISTORY_TITLE)

# TC_HISTORY_TAB_016
# 기록 상세페이지 - 감상평 영역 클릭 
def test_history_tab_review_area_tapped_shows_sheet(history_tab_with_data):
    helper_open_first_history_detail(history_tab_with_data)
    helper_tap_review_area(history_tab_with_data)

    history_tab_with_data.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "감상평 수정"
    )

# TC_HISTORY_TAB_017
# 감상평 수정 시트 - 저장 버튼 비활성화
def test_history_tab_review_save_button_disabled_when_content_empty(history_tab_with_data):
    helper_open_first_history_detail(history_tab_with_data)
    helper_tap_review_area(history_tab_with_data)

    history_tab_with_data.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypeTextView"
    ).clear()
    time.sleep(1)

    save_button = history_tab_with_data.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "저장"`]'
    )
    assert not save_button.is_enabled()

    history_tab_with_data.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "인상 깊은 문장이나 생각을 남겨보세요"
    )

# TC_HISTORY_TAB_019
# 기록 추가 버튼 클릭
@pytest.mark.smoke
def test_history_tab_add_button_tapped_navigate_to_add_history(history_tab_screen):
    helper_tap_top_plus_button(history_tab_screen)

    history_tab_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "여행을 마쳤나요?"
    )
