# 탭 화면(예약/기록 등) 테스트가 함께 쓰는 공용 헬퍼.
# 탭 전용 동작은 각 폴더(wish_tab/, history_tab/)의 *_helper.py 에 둔다.

from appium.webdriver.common.appiumby import AppiumBy

import time

# 여행/예약/기록 삭제 알럿 메시지 (앱 코드: presentDeleteAlert(message:))
DELETE_ALERT_MESSAGE = "이 여행을 삭제할까요?"

# 요소의 화면상 y / x 좌표 (정렬, min 의 key 로 사용)
def helper_element_y(element):
    return element.rect["y"]

def helper_element_x(element):
    return element.rect["x"]

# 타이틀(접근성 ID) 라벨이 화면에 존재하는지
def helper_is_title_present(driver, title):
    return len(driver.find_elements(AppiumBy.ACCESSIBILITY_ID, title)) > 0

# 첫 번째 테이블 셀(티켓) 반환
def helper_first_table_cell(driver):
    return driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTable/XCUIElementTypeCell[1]'
    )

# 요소 롱프레스 (앱 코드의 롱프레스 최소 시간은 0.5초)
def helper_long_press(driver, element, duration=1.5):
    driver.execute_script("mobile: touchAndHold", {
        "elementId": element.id,
        "duration": duration
    })
    time.sleep(1)

# 삭제 알럿 메시지가 출력 중인지 (리스트로 반환)
def helper_find_delete_alert_message(driver):
    return driver.find_elements(
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeAlert/**/XCUIElementTypeStaticText[`name == "{DELETE_ALERT_MESSAGE}"`]'
    )

# 알럿 버튼 반환 ("취소" / "삭제")
def helper_find_alert_button(driver, title):
    return driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeAlert/**/XCUIElementTypeButton[`name == "{title}"`]'
    )

# 상단 '+' 버튼 클릭 (이미지 에셋 이름 "plus" 로 노출되는 버튼 중 화면 가장 위에 있는 것)
def helper_tap_top_plus_button(driver):
    buttons = driver.find_elements(
        AppiumBy.ACCESSIBILITY_ID,
        "plus"
    )
    assert len(buttons) > 0, "상단 + 버튼을 찾지 못했습니다."

    min(buttons, key=helper_element_y).click()
    time.sleep(1)

# 화면을 아래로 스크롤 (좌표 기반이라 기기 크기와 무관)
def helper_scroll_down(driver):
    size = driver.get_window_size()
    driver.execute_script("mobile: dragFromToForDuration", {
        "duration": 0.5,
        "fromX": size["width"] / 2,
        "fromY": size["height"] * 0.75,
        "toX": size["width"] / 2,
        "toY": size["height"] * 0.25
    })
    time.sleep(1)

# 타이틀 라벨이 화면에 보일 때까지 최대 max_count 번 스크롤
def helper_scroll_until_visible(driver, title, max_count=4):
    for _ in range(max_count):
        found = driver.find_elements(AppiumBy.ACCESSIBILITY_ID, title)
        if found and found[0].is_displayed():
            return found[0]
        helper_scroll_down(driver)

    raise AssertionError(f"스크롤 후에도 '{title}' 를 찾지 못했습니다.")
