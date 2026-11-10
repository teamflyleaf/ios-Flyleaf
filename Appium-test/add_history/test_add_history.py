from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from enums.Airport import Airport
from enums.DateField import DateField
from add_history.add_history_helper import (
    helper_navigate_to_check,
    helper_navigate_to_route_step,
)
from helpers.register_flow_helper import (
    helper_search_and_select_book,
    helper_select_airport,
    helper_select_date,
)
from datetime import datetime

import time
import pytest

# TC_ADD_HISTORY_001
# 첫 진입 시 UI 테스트
@pytest.mark.smoke
def test_add_history_default_ui(add_history_screen):
    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "여행을 마쳤나요?"
    )

    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "다 읽은 책을 추가해보세요"
    )

    add_book_button_title = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "다 읽은 책"`][2]'
    )

    other_title_elements = [
        "시작일",
        "종료일",
        "감상평"
    ]

    other_button_title_elements = [
        "시작일을 선택해주세요",
        "종료일을 선택해주세요",
        "이 책은 어땠나요?"
    ]

    for title in other_title_elements:
        elements = add_history_screen.find_elements(
            AppiumBy.ACCESSIBILITY_ID,
            title
        )
        assert len(elements) == 0

    for button_title in other_button_title_elements:
        elements = add_history_screen.find_elements(
            AppiumBy.IOS_CLASS_CHAIN,
            f'**/XCUIElementTypeTextField[`value == "{button_title}"`]'
        )
        assert len(elements) == 0

# TC_ADD_HISTORY_002
# 다 읽은 책 등록 버튼 테스트
def test_add_history_add_book_button_tapped(add_history_screen):
    button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeWindow/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[4]/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeButton'
    )
    button.click()
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "검색어를 입력하세요"`]'
    )
    

# TC_ADD_HISTORY_003
# 다 읽은 책 등록 테스트
def test_add_history_add_book(add_history_screen, search_keywords):
    helper_search_and_select_book(add_history_screen, search_keywords[0])

    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        search_keywords[0]
    )

    add_history_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        'label CONTAINS "지은이" OR label CONTAINS "옮긴이"'
    )

# TC_ADD_HISTORY_004
# 시작일 버튼 테스트
def test_add_history_start_date_button_tapped(add_history_screen, search_keywords):
    helper_search_and_select_book(add_history_screen, search_keywords[0])

    button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "시작일을 선택해주세요"`]'
    )
    button.click()
    time.sleep(1)

    picker = add_history_screen.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )
    assert picker.is_displayed()

# TC_ADD_HISTORY_005
# 시작일 선택 디폴트 날짜 테스트
def test_add_history_start_date_default_date(add_history_screen, search_keywords):
    helper_search_and_select_book(add_history_screen, search_keywords[0])

    button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "시작일을 선택해주세요"`]'
    )
    button.click()
    time.sleep(1)

    today = datetime.now()
    convert_dates = [
        f"{today.year}년", 
        f"{today.month}월", 
        f"{today.day}일"
    ]

    picker = add_history_screen.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )

    wheels = picker.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePickerWheel"
    )

    actual = [wheel.get_attribute("value") for wheel in wheels]

    assert actual == convert_dates

# TC_ADD_HISTORY_006
# 시작일 선택 테스트
def test_add_history_start_date_select(add_history_screen, search_keywords):
    helper_search_and_select_book(add_history_screen, search_keywords[0])

    helper_select_date(add_history_screen, DateField.START)

    today = datetime.now()
    date_label = today.strftime("%Y.%m.%d")

    add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeTextField[`value == "{date_label}"`]'
    )

# TC_ADD_HISTORY_007
# 종료일 버튼 테스트
def test_add_history_end_date_button_tapped(add_history_screen, search_keywords):
    helper_search_and_select_book(add_history_screen, search_keywords[0])

    button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "종료일을 선택해주세요"`]'
    )
    button.click()
    time.sleep(1)

    picker = add_history_screen.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )
    assert picker.is_displayed()

# TC_ADD_HISTORY_08
# 종료일 선택 디폴트 날짜 테스트
def test_add_history_end_date_default_date(add_history_screen, search_keywords):
    helper_search_and_select_book(add_history_screen, search_keywords[0])

    button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "종료일을 선택해주세요"`]'
    )
    button.click()
    time.sleep(1)

    today = datetime.now()
    convert_dates = [
        f"{today.year}년", 
        f"{today.month}월", 
        f"{today.day}일"
    ]

    picker = add_history_screen.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )

    wheels = picker.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePickerWheel"
    )

    actual = [wheel.get_attribute("value") for wheel in wheels]

    assert actual == convert_dates

# TC_ADD_HISTORY_009
# 종료일 선택 테스트
def test_add_history_end_date_select(add_history_screen, search_keywords):
    helper_search_and_select_book(add_history_screen, search_keywords[0])

    helper_select_date(add_history_screen, DateField.END)

    today = datetime.now()
    date_label = today.strftime("%Y.%m.%d")

    add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeTextField[`value == "{date_label}"`]'
    )

# TC_ADD_HISTORY_011
# 종료일은 시작일보다 앞설 수 없다
def test_add_history_end_date_cannot_precede_start_date(add_history_screen, search_keywords):
    helper_search_and_select_book(add_history_screen, search_keywords[0])

    helper_select_date(add_history_screen, DateField.START)

    start_label = datetime.now().strftime("%Y.%m.%d")

    add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "종료일을 선택해주세요"`]'
    ).click()
    time.sleep(1)

    picker = add_history_screen.find_element(AppiumBy.CLASS_NAME, "XCUIElementTypePicker")
    day_wheel = picker.find_elements(AppiumBy.CLASS_NAME, "XCUIElementTypePickerWheel")[2]

    add_history_screen.execute_script("mobile: selectPickerWheelValue", {
        "elementId": day_wheel.id,
        "order": "previous"
    })

    add_history_screen.find_element(AppiumBy.ACCESSIBILITY_ID, "완료").click()
    time.sleep(1)

    fields = add_history_screen.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypeTextField"
    )
    end_field = fields[1]
    assert end_field.get_attribute("value") == start_label

# TC_ADD_HISTORY_012
# 다음 버튼 활성화 테스트
def test_add_history_next_button_enabled(add_history_screen, search_keywords):
    assert len(add_history_screen.find_elements(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )) == 0

    helper_search_and_select_book(add_history_screen, search_keywords[0])
    helper_select_date(add_history_screen, DateField.START)
    helper_select_date(add_history_screen, DateField.END)

    next_button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    assert next_button.is_enabled()

# TC_ADD_HISTORY_013
# 감상평 입력 테스트 - 현재 입력 글자 UI 반영 테스트
def test_add_history_review_character_count_updates(add_history_screen, search_keywords, review_normal):
    helper_search_and_select_book(add_history_screen, search_keywords[0])

    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "0/100"
    )

    textField = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "이 책은 어땠나요?"`]'
    )

    textField.send_keys(review_normal)
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        f'{len(review_normal)}/100'
    )

# TC_ADD_HISTORY_015
# 다음 버튼 네비게이션 테스트
@pytest.mark.smoke
def test_add_history_book_next_button_tapped_navigate_to_route(add_history_screen, search_keywords):
    helper_search_and_select_book(add_history_screen, search_keywords[0])
    helper_select_date(add_history_screen, DateField.START)
    helper_select_date(add_history_screen, DateField.END)

    next_button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )

    next_button.click()
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "어디에서 출발했나요?"
    )

# TC_ADD_HISTORY_016
# 출발지 등록 버튼 네비게이션 테스트
def test_add_history_departure_button_tapped_navigate_to_departure_search(add_history_screen, search_keywords):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])
    button = add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "버튼을 눌러 출발지를 등록하세요"
    )

    button.click()
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "출발 공항 검색 (공항명/도시/코드)"`]'
    )

# TC_ADD_HISTORY_017
# 도착지 등록 버튼 네비게이션 테스트
def test_add_history_destination_button_tapped_navigate_to_destination_search(add_history_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])
    helper_select_airport(add_history_screen, airports_normal[0], Airport.DEPARTURE)

    button = add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "버튼을 눌러 목적지를 등록하세요"
    )

    button.click()
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "도착 공항 검색 (공항명/도시/코드)"`]'
    )

# TC_ADD_HISTORY_018
# 출발지 선택 테스트
def test_add_history_departure_select(add_history_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])
    helper_select_airport(add_history_screen, airports_normal[0], Airport.DEPARTURE)

    add_history_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        f'label CONTAINS "{airports_normal[0]}"'
    )

# TC_ADD_HISTORY_019
# 도착지 선택 테스트
def test_add_history_destination_select(add_history_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])
    helper_select_airport(add_history_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_history_screen, airports_normal[1], Airport.DESTINATION)

    add_history_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        f'label CONTAINS "{airports_normal[1]}"'
    )

# TC_ADD_HISTORY_020
# 도착지 선택 먼저 선택 시 경고 알럿 출력 테스트
def test_add_history_destination_button_tapped_without_departure_shows_alert(add_history_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])
    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        f'버튼을 눌러 목적지를 등록하세요'
    ).click()
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "출발지 먼저 선택"`]'
    )

# TC_ADD_HISTORY_021
# 공항 중복 알럿 출력 테스트
def test_add_history_same_departure_and_destination_shows_alert(add_history_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])
    helper_select_airport(add_history_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_history_screen, airports_normal[0], Airport.DESTINATION)

    add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "선택 불가"`]'
    )

# TC_ADD_HISTORY_022
# 출발지/목적지 등록 페이지 이전 버튼 탭 테스트
def test_add_history_before_button_tapped(add_history_screen, search_keywords):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])

    button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "이전"`]'
    )
    button.click()
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "여행을 마쳤나요?"
    )


# TC_ADD_HISTORY_023
# 출발지/목적지 등록 페이지 이전/다음버튼 출력 테스트
def test_add_history_before_button_and_next_button_visible(add_history_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])
    helper_select_airport(add_history_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_history_screen, airports_normal[1], Airport.DESTINATION)

    elements = [
        "이전",
        "다음"
    ]

    for title in elements:
        add_history_screen.find_element(
            AppiumBy.IOS_CLASS_CHAIN,
            f'**/XCUIElementTypeButton[`name == "{title}"`]'
        )

# TC_ADD_HISTORY_024
# 출발지/목적지 등록 페이지 다음 버튼 탭
@pytest.mark.smoke
def test_add_history_route_next_button_tapped_navigate_to_check(add_history_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])
    helper_select_airport(add_history_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_history_screen, airports_normal[1], Airport.DESTINATION)

    button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    button.click()
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "이 여행이 맞을까요?"
    )

# TC_ADD_HISTORY_025
# 최종 확인 페이지 이전 버튼 탭
def test_add_history_check_step_prev_button_tapped_navigate_to_route_step(add_history_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])
    helper_select_airport(add_history_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_history_screen, airports_normal[1], Airport.DESTINATION)


    button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    button.click()
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "이 여행이 맞을까요?"
    )

    button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "이전"`]'
    )
    button.click()
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "어디에서 출발했나요?"
    )

# TC_ADD_HISTORY_026
# 최종 확인 페이지 다음 버튼 네비게이션 테스트
def test_add_history_check_step_next_button_tapped_navigate_to_upload_completed(add_history_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_history_screen, search_keywords[0])
    helper_navigate_to_check(add_history_screen, airports_normal)

    button = add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )

    button.click()
    time.sleep(1)

    add_history_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "기록"`]'
    )

