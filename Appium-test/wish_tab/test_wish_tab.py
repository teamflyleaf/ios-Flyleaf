from appium.webdriver.common.appiumby import AppiumBy

from helpers.tab_helper import (
    helper_find_alert_button,
    helper_find_delete_alert_message,
    helper_first_table_cell,
    helper_long_press,
)
from wish_tab.wish_tab_helper import helper_swipe_first_wish_ticket

import time

# TC_WISH_TAB_002
# 티켓 롱프레스 테스트
def test_wish_tab_ticket_long_press_shows_delete_alert(wish_tab_with_data):
    helper_long_press(wish_tab_with_data, helper_first_table_cell(wish_tab_with_data))

    assert len(helper_find_delete_alert_message(wish_tab_with_data)) > 0

# TC_WISH_TAB_003
# 티켓 테스트 - 롱프레스 - 삭제 취소 (알럿이 닫힘)
def test_wish_tab_ticket_long_press_cancel(wish_tab_with_data):
    helper_long_press(wish_tab_with_data, helper_first_table_cell(wish_tab_with_data))
    assert len(helper_find_delete_alert_message(wish_tab_with_data)) > 0

    helper_find_alert_button(wish_tab_with_data, "취소").click()
    time.sleep(1)

    assert len(helper_find_delete_alert_message(wish_tab_with_data)) == 0

# TC_WISH_TAB_005
# 티켓 테스트 - 스와이프 제스처 (좌 -> 우 스와이프 시 탑승권 발급 페이지로 이동. 발급 완료는 하지 않음)
def test_wish_tab_ticket_swipe_navigate_to_ticket_issue(wish_tab_with_data):
    helper_swipe_first_wish_ticket(wish_tab_with_data)

    wish_tab_with_data.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "탑승권 발급"
    )
