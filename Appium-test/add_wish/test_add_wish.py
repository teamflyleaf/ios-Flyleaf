from appium.webdriver.common.appiumby import AppiumBy

from enums.Airport import Airport
from add_wish.add_wish_helper import (
    helper_navigate_to_check,
    helper_navigate_to_route_step,
)
from helpers.register_flow_helper import (
    helper_search_and_select_book,
    helper_select_airport,
)

import time
import pytest

# TC_ADD_WISH_001
# 읽고 싶은 책 등록 페이지 UI 확인
@pytest.mark.smoke
def test_add_wish_default_ui(add_wish_screen):
    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "다음 여행을 준비해볼까요?"
    )

    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "읽고 싶은 책을 찾아보세요"
    )

    add_book_button_title = add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "읽고 싶은 책"`][2]'
    )

    other_title_elements = [
        "읽고 싶은 이유"
    ]

    other_button_title_elements = [
        "왜 이 책을 읽고 싶나요?"
    ]

    for title in other_title_elements:
        elements = add_wish_screen.find_elements(
            AppiumBy.ACCESSIBILITY_ID,
            title
        )
        assert len(elements) == 0

    for button_title in other_button_title_elements:
        elements = add_wish_screen.find_elements(
            AppiumBy.IOS_CLASS_CHAIN,
            f'**/XCUIElementTypeTextField[`value == "{button_title}"`]'
        )
        assert len(elements) == 0

# TC_ADD_WISH_002
# 읽고 싶은 책 등록 버튼 테스트
def test_add_wish_add_book_button_tapped(add_wish_screen):
    button = add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[4]/XCUIElementTypeOther/XCUIElementTypeButton'
    )
    button.click()
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "검색어를 입력하세요"`]'
    )

# TC_ADD_WISH_003
# 읽고 싶은 책 등록 테스트
def test_add_wish_add_book(add_wish_screen, search_keywords):
    helper_search_and_select_book(add_wish_screen, search_keywords[0])

    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        search_keywords[0]
    )

    add_wish_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        'label CONTAINS "지은이" OR label CONTAINS "옮긴이"'
    )

# TC_ADD_WISH_004
# 읽고 싶은 이유 텍스트 제한 테스트
def test_add_wish_reason_text_count_shown(add_wish_screen, search_keywords, review_normal):
    helper_search_and_select_book(add_wish_screen, search_keywords[0])

    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "0/30"
    )

    textField = add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "왜 이 책을 읽고 싶나요?"`]'
    )

    textField.send_keys(review_normal)
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        f'{len(review_normal)}/30'
    )

# TC_ADD_WISH_005
# 책 등록 페이지 다음 버튼 네비게이션 테스트
@pytest.mark.smoke
def test_add_wish_next_button_tapped_navigate_to_route_step(add_wish_screen, search_keywords):
    helper_search_and_select_book(add_wish_screen, search_keywords[0])

    button = add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    button.click()
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        '어디에서 출발할까요?'
    )

# TC_ADD_WISH_006
# 출발지 등록 버튼 네비게이션 테스트
def test_add_wish_departure_button_tapped_navigate_to_departure_search(add_wish_screen, search_keywords):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    button = add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "버튼을 눌러 출발지를 등록하세요"
    )

    button.click()
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "출발 공항 검색 (공항명/도시/코드)"`]'
    )

# TC_ADD_WISH_007
# 도착지 등록 버튼 네비게이션 테스트
def test_add_wish_destination_button_tapped_navigate_to_destination_search(add_wish_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    helper_select_airport(add_wish_screen, airports_normal[0], Airport.DEPARTURE)

    button = add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "버튼을 눌러 목적지를 등록하세요"
    )

    button.click()
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "도착 공항 검색 (공항명/도시/코드)"`]'
    )

# TC_ADD_WISH_008
# 출발지 선택 테스트
def test_add_wish_departure_select(add_wish_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    helper_select_airport(add_wish_screen, airports_normal[0], Airport.DEPARTURE)

    add_wish_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        f'label CONTAINS "{airports_normal[0]}"'
    )

# TC_ADD_WISH_009
# 도착지 선택 테스트
def test_add_wish_destination_select(add_wish_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    helper_select_airport(add_wish_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_wish_screen, airports_normal[1], Airport.DESTINATION)

    add_wish_screen.find_element(
        AppiumBy.IOS_PREDICATE,
        f'label CONTAINS "{airports_normal[1]}"'
    )

# TC_ADD_WISH_010
# 도착지 선택 먼저 선택 시 경고 알럿 출력 테스트
def test_add_wish_destination_button_tapped_without_departure_shows_alert(add_wish_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        f'버튼을 눌러 목적지를 등록하세요'
    ).click()
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "출발지 먼저 선택"`]'
    )

# TC_ADD_WISH_011
# 공항 중복 알럿 출력 테스트
def test_add_wish_same_departure_and_destination_shows_alert(add_wish_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    helper_select_airport(add_wish_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_wish_screen, airports_normal[0], Airport.DESTINATION)

    add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeStaticText[`name == "선택 불가"`]'
    )

# TC_ADD_WISH_012
# 출발지/목적지 등록 페이지 이전 버튼 탭 테스트
def test_add_wish_before_button_tapped(add_wish_screen, search_keywords):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])

    button = add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "이전"`]'
    )
    button.click()
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "다음 여행을 준비해볼까요?"
    )


# TC_ADD_WISH_013
# 출발지/목적지 등록 페이지 이전/다음버튼 출력 테스트
def test_add_wish_before_button_and_next_button_visible(add_wish_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    helper_select_airport(add_wish_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_wish_screen, airports_normal[1], Airport.DESTINATION)

    elements = [
        "이전",
        "다음"
    ]

    for title in elements:
        add_wish_screen.find_element(
            AppiumBy.IOS_CLASS_CHAIN,
            f'**/XCUIElementTypeButton[`name == "{title}"`]'
        )

# TC_ADD_WISH_014
# 출발지/목적지 등록 페이지 다음 버튼 탭
@pytest.mark.smoke
def test_add_wish_route_next_button_tapped_navigate_to_check(add_wish_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    helper_select_airport(add_wish_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_wish_screen, airports_normal[1], Airport.DESTINATION)

    button = add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    button.click()
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "이 여행이 맞을까요?"
    )

# TC_ADD_WISH_015
# 최종 확인 페이지 이전 버튼 탭
def test_add_wish_check_step_prev_button_tapped_navigate_to_route_step(add_wish_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    helper_select_airport(add_wish_screen, airports_normal[0], Airport.DEPARTURE)
    helper_select_airport(add_wish_screen, airports_normal[1], Airport.DESTINATION)


    button = add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    button.click()
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "이 여행이 맞을까요?"
    )

    button = add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "이전"`]'
    )
    button.click()
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "어디에서 출발할까요?"
    )

# TC_ADD_WISH_016
# 최종 확인 페이지 다음 버튼 네비게이션 테스트
@pytest.mark.smoke
def test_add_wish_check_step_next_button_tapped_navigate_to_ticket_issue(add_wish_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    helper_navigate_to_check(add_wish_screen, airports_normal)

    button = add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    )
    button.click()
    time.sleep(1)

    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "탑승권 발급"
    )

# TC_ADD_WISH_017
# 탑승권 발급 페이지 완료 버튼 비활성화 테스트 (티켓을 찢기 전)
def test_add_wish_ticket_issue_complete_button_disabled(add_wish_screen, search_keywords, airports_normal):
    helper_navigate_to_route_step(add_wish_screen, search_keywords[0])
    helper_navigate_to_check(add_wish_screen, airports_normal)

    add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "다음"`]'
    ).click()
    time.sleep(1)

    # 탑승권 발급 페이지에 도달했는지 먼저 확인
    add_wish_screen.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "탑승권 발급"
    )

    complete_button = add_wish_screen.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeButton[`name == "완료"`]'
    )
    assert not complete_button.is_enabled()