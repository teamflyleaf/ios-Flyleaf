from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from enums.Airport import Airport
from enums.DateField import DateField
from add_journey.add_journey_helper import (
    helper_navigate_to_check,
    helper_navigate_to_route_step,
)
from helpers.register_flow_helper import (
    helper_search_and_select_book,
    helper_select_airport,
    helper_select_date,
    helper_select_one_page,
    helper_select_zero_page,
)
from datetime import datetime

import time
import pytest

# TC_ADD_JOURNEY_001
# 읽고 있는 책 등록 페이지 UI 확인
@pytest.mark.smoke
def test_add_journey_default_ui(add_journey_screen):
    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "이미 시작한 여행이 있나요?"
    )

    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "읽고 있는 책을 찾아보세요"
    )

    add_book_button_title = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "읽고 있는 책"`][2]'
    )

    other_title_elements = [
        "시작일",
        "감상평",
        "읽은 페이지 수"
    ]

    other_button_title_elements = [
        "시작일을 선택해주세요"
    ]

    for title in other_title_elements:
        elements = add_journey_screen.find_elements(
            AppiumBy.ACCESSIBILITY_ID,
            title
        )
        assert len(elements) == 0

    for button_title in other_button_title_elements:
        elements = add_journey_screen.find_elements(
            AppiumBy.IOS_CLASS_CHAIN,
            f'**/XCUIElementTypeTextField[`value == "{button_title}"`]'
        )
        assert len(elements) == 0

# TC_ADD_JOURNEY_002
# 읽고 있는 책 등록 버튼 테스트
def test_add_journey_add_book_button_tapped(add_journey_screen):
    button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeWindow/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[4]/XCUIElementTypeOther/XCUIElementTypeButton'
    )
    button.click()
    time.sleep(1)

    add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "검색어를 입력하세요"`]'
    )

# TC_ADD_JOURNEY_003
# 읽고 있는 책 등록 테스트
def test_add_journey_add_book(add_journey_screen, search_keywords):
    helper_search_and_select_book(add_journey_screen, search_keywords[0])

    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        search_keywords[0]
    )

    add_journey_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        'label CONTAINS "지은이" OR label CONTAINS "옮긴이"'
    )

# TC_ADD_JOURNEY_004
# 시작일 버튼 테스트
def test_add_journey_start_date_button_tapped(add_journey_screen, search_keywords):
    helper_search_and_select_book(add_journey_screen, search_keywords[0])

    button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "시작일을 선택해주세요"`]'
    )
    button.click()
    time.sleep(1)

    picker = add_journey_screen.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )
    assert picker.is_displayed()

# TC_ADD_JOURNEY_005
# 시작일 선택 디폴트 날짜 테스트
def test_add_journey_start_date_default_date(add_journey_screen, search_keywords):
    helper_search_and_select_book(add_journey_screen, search_keywords[0])

    button = add_journey_screen.find_element(
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

    picker = add_journey_screen.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )

    wheels = picker.find_elements(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePickerWheel"
    )

    actual = [wheel.get_attribute("value") for wheel in wheels]

    assert actual == convert_dates

# TC_ADD_JOURNEY_006
# 시작일 선택 테스트
def test_add_journey_start_date_select(add_journey_screen, search_keywords):
    helper_search_and_select_book(add_journey_screen, search_keywords[0])

    helper_select_date(add_journey_screen, DateField.START)

    today = datetime.now()
    date_label = today.strftime("%Y.%m.%d")

    add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeTextField[`value == "{date_label}"`]'
    )

# TC_ADD_JOURNEY_007
# 읽은 페이지수 버튼 테스트
def test_add_journey_reading_page_select_tapped(add_journey_screen, search_keywords):
    helper_search_and_select_book(add_journey_screen, search_keywords[0])

    button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/X' \
        'CUIElementTypeTextField[`value BEGINSWITH "0 / "`]'
    )
    button.click()
    time.sleep(1)

    picker = add_journey_screen.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )
    assert picker.is_displayed()

# TC_ADD_JOURNEY_008
# 읽은 페이지수 버튼 테스트 - 디폴트 값
def test_add_journey_reading_page_default_value(add_journey_screen, search_keywords):
    helper_search_and_select_book(add_journey_screen, search_keywords[0])

    button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value BEGINSWITH "0 / "`]'
    )
    field_value = button.get_attribute("value")
    button.click()
    time.sleep(1)

    picker = add_journey_screen.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )
    wheel = picker.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePickerWheel"
    )
    wheel_value = wheel.get_attribute("value")

    read_pages, total_pages = wheel_value.split(" / ")
    assert read_pages == "0"
    assert wheel_value == field_value

# TC_ADD_JOURNEY_009
# 읽은 페이지수 버튼 테스트 - 페이지 선택
def test_add_journey_reading_page_select(add_journey_screen, search_keywords):
    helper_search_and_select_book(add_journey_screen, search_keywords[0])
    total_pages = helper_select_one_page(add_journey_screen)

    add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeTextField[`value == "2 / {total_pages}"`]'
    )

# TC_ADD_JOURNEY_010
# 읽은 페이지수 버튼 테스트 - 예외 테스트 (0 선택)
def test_add_journey_reading_page_zero_select(add_journey_screen, search_keywords):
    helper_search_and_select_book(add_journey_screen, search_keywords[0])
    helper_select_zero_page(add_journey_screen)

    button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    assert not button.is_enabled()


# TC_ADD_JOURNEY_011
# 다음 버튼 활성화 테스트
def test_add_journey_next_button_enabled(add_journey_screen, search_keywords):
    assert len(add_journey_screen.find_elements(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )) == 0

    helper_search_and_select_book(add_journey_screen, search_keywords[0])
    helper_select_date(add_journey_screen, DateField.START)
    helper_select_one_page(add_journey_screen)

    next_button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    assert next_button.is_enabled()

# TC_ADD_HISTORY_012
# 다음 버튼 네비게이션 테스트
@pytest.mark.smoke
def test_add_journey_book_next_button_tapped_navigate_to_route(add_journey_screen, search_keywords):
    helper_search_and_select_book(add_journey_screen, search_keywords[0])
    helper_select_date(add_journey_screen, DateField.START)
    helper_select_one_page(add_journey_screen)

    next_button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )

    next_button.click()
    time.sleep(1)

    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "어디에서 출발했나요?"
    )

# TC_ADD_JOURNEY_013
# 출발지 등록 버튼 네비게이션 테스트
def test_add_journey_departure_button_tapped_navigate_to_departure_search(add_journey_screen, search_keywords):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    button = add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "버튼을 눌러 출발지를 등록하세요"
    )

    button.click()
    time.sleep(1)

    add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "출발 공항 검색 (공항명/도시/코드)"`]'
    )

# TC_ADD_JOURNEY_014
# 도착지 등록 버튼 네비게이션 테스트
def test_add_journey_destination_button_tapped_navigate_to_destination_search(add_journey_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    helper_select_airport(add_journey_screen, airports_normal[0], Airport.DEPARTURE)

    button = add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "버튼을 눌러 목적지를 등록하세요"
    )

    button.click()
    time.sleep(1)

    add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "도착 공항 검색 (공항명/도시/코드)"`]'
    )

# TC_ADD_JOURNEY_015
# 출발지 선택 테스트
def test_add_journey_departure_select(add_journey_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    helper_select_airport(add_journey_screen, airports_normal[0], Airport.DEPARTURE)

    add_journey_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        f'label CONTAINS "{airports_normal[0]}"'
    )

# TC_ADD_JOURNEY_016
# 도착지 선택 테스트
def test_add_journey_destination_select(add_journey_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    helper_select_airport(add_journey_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_journey_screen, airports_normal[1], Airport.DESTINATION)

    add_journey_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        f'label CONTAINS "{airports_normal[1]}"'
    )

# TC_ADD_JOURNEY_017
# 도착지 선택 먼저 선택 시 경고 알럿 출력 테스트
def test_add_journey_destination_button_tapped_without_departure_shows_alert(add_journey_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        f'버튼을 눌러 목적지를 등록하세요'
    ).click()
    time.sleep(1)

    add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "출발지 먼저 선택"`]'
    )

# TC_ADD_JOURNEY_018
# 공항 중복 알럿 출력 테스트
def test_add_journey_same_departure_and_destination_shows_alert(add_journey_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    helper_select_airport(add_journey_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_journey_screen, airports_normal[0], Airport.DESTINATION)

    add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "선택 불가"`]'
    )

# TC_ADD_JOURNEY_019
# 출발지/목적지 등록 페이지 이전 버튼 탭 테스트
def test_add_journey_before_button_tapped(add_journey_screen, search_keywords):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])

    button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "이전"`]'
    )
    button.click()
    time.sleep(1)

    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "이미 시작한 여행이 있나요?"
    )


# TC_ADD_JOURNEY_020
# 출발지/목적지 등록 페이지 이전/다음버튼 출력 테스트
def test_add_journey_before_button_and_next_button_visible(add_journey_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    helper_select_airport(add_journey_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_journey_screen, airports_normal[1], Airport.DESTINATION)

    elements = [
        "이전",
        "다음"
    ]

    for title in elements:
        add_journey_screen.find_element(
            AppiumBy.IOS_CLASS_CHAIN,
            f'**/XCUIElementTypeButton[`name == "{title}"`]'
        )

# TC_ADD_JOURNEY_021
# 출발지/목적지 등록 페이지 다음 버튼 탭
@pytest.mark.smoke
def test_add_journey_route_next_button_tapped_navigate_to_check(add_journey_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    helper_select_airport(add_journey_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_journey_screen, airports_normal[1], Airport.DESTINATION)

    button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    button.click()
    time.sleep(1)

    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "이 여행이 맞을까요?"
    )

# TC_ADD_JOURNEY_022
# 최종 확인 페이지 이전 버튼 탭
def test_add_journey_check_step_prev_button_tapped_navigate_to_route_step(add_journey_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    helper_select_airport(add_journey_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_journey_screen, airports_normal[1], Airport.DESTINATION)


    button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    button.click()
    time.sleep(1)

    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "이 여행이 맞을까요?"
    )

    button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "이전"`]'
    )
    button.click()
    time.sleep(1)

    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "어디에서 출발했나요?"
    )

# TC_ADD_JOURNEY_023
# 최종 확인 페이지 다음 버튼 네비게이션 테스트
@pytest.mark.smoke
def test_add_journey_check_step_next_button_tapped_navigate_to_ticket_issue(add_journey_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    helper_navigate_to_check(add_journey_screen, airports_normal)

    button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    button.click()
    time.sleep(1)

    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "탑승권 발급"
    )

# TC_ADD_JOURNEY_024
# 탑승권 발급 페이지 완료 버튼 비활성화 테스트 (티켓을 찢기 전)
def test_add_journey_ticket_issue_complete_button_disabled(add_journey_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_journey_screen, search_keywords[0])
    helper_navigate_to_check(add_journey_screen, airports_normal)

    add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    ).click()
    time.sleep(1)

    # 탑승권 발급 페이지에 도달했는지 먼저 확인
    add_journey_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "탑승권 발급"
    )

    complete_button = add_journey_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "완료"`]'
    )
    assert not complete_button.is_enabled()