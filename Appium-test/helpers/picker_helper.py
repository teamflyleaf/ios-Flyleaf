# 페이지 피커(NeutralPagePickerField)용 공용 헬퍼.
# 피커 휠의 값은 "현재 / 전체" 형식이다. (예: "3 / 176")
# `mobile: selectPickerWheelValue` 의 offset(기본 0.2)이 크면 한 번에 여러 칸 넘어갈 수 있어서,
# 이동 후 실제 값을 다시 읽어 목표 값과 비교하며 보정한다.
# (https://appium.readthedocs.io/en/latest/en/writing-running-appium/ios/ios-xctest-mobile-gestures/)

from appium.webdriver.common.appiumby import AppiumBy

import time

MAX_WHEEL_ADJUST_COUNT = 30

# 현재 화면의 페이지 피커 휠 반환
def helper_get_picker_wheel(driver):
    picker = driver.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )
    return picker.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePickerWheel"
    )

# 휠 값("3 / 176")을 (현재 페이지, 전체 페이지)로 파싱
def helper_parse_wheel_value(wheel):
    current, total = wheel.get_attribute("value").split(" / ")
    return int(current), int(total)

# 이미 열려 있는 피커에서 목표 페이지가 될 때까지 휠을 움직인다. (완료 버튼은 누르지 않는다)
# 반환값: 전체 페이지 수 (API 값이라 책마다 다르므로 검증용으로 돌려준다)
def helper_move_picker_to_page(driver, page):
    wheel = helper_get_picker_wheel(driver)
    current, total = helper_parse_wheel_value(wheel)

    assert 0 <= page <= total, f"선택 가능한 범위(0~{total})를 벗어난 페이지: {page}"

    for _ in range(MAX_WHEEL_ADJUST_COUNT):
        if current == page:
            return total

        driver.execute_script("mobile: selectPickerWheelValue", {
            "elementId": wheel.id,
            "order": "next" if page > current else "previous"
        })
        time.sleep(0.3)
        current, _ = helper_parse_wheel_value(wheel)

    raise AssertionError(f"피커를 {page}페이지로 이동하지 못했습니다. (현재 {current})")
