from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from enums.DateField import DateField
from enums.Airport import Airport

import time

# 요소가 나타낼 때까지 대기 하고 반환 함. (최대 10초)
def helper_wait_for(driver, by, value, timeout=10):
    return WebDriverWait(driver, timeout).until(
        EC.presence_of_element_located((by, value))
    )

ADD_BOOK_BUTTON_LOCATORS = [
    # 다 읽은 책
    '**/XCUIElementTypeWindow/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[4]/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeButton',
    # 읽고 있는 책
    '**/XCUIElementTypeWindow/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[4]/XCUIElementTypeOther/XCUIElementTypeButton',
]
# 후보 중 화면에 존재하는 첫 번째 책 등록 버튼을 누른다.
def helper_tap_add_book_button(driver):
    for chain in ADD_BOOK_BUTTON_LOCATORS:
        found = driver.find_elements(AppiumBy.IOS_CLASS_CHAIN, chain)
        if found:
            found[0].click()
            time.sleep(1)
            return
    raise AssertionError("책 등록 버튼을 찾지 못했습니다. ADD_BOOK_BUTTON_LOCATORS 를 확인하세요.")

# 책 등록 버튼 클릭 -> 검색 -> 첫 번째 결과 선택
def helper_search_and_select_book(driver, keyword):
    helper_tap_add_book_button(driver)
    helper_search_and_pick_book(driver, keyword)

# 책 검색 화면에서 검색어를 입력하고 첫 번째 결과를 선택하는 플로우
def helper_search_and_pick_book(driver, keyword):
    searchbar = driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value == "검색어를 입력하세요"`]'
    )

    searchbar.send_keys(keyword + "\n")
    time.sleep(1)

    item = helper_wait_for(
        driver,
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeStaticText[`name == "{keyword}"`][1]'
    )
    item.click()
    time.sleep(1)

# 시작일, 종료일 날짜 선택 헬퍼
def helper_select_date(driver, date_field: DateField):
    button = driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        f'**/XCUIElementTypeTextField[`value == "{date_field.value}을 선택해주세요"`]'
    )
    button.click()
    time.sleep(1)

    done_button = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "완료"
    )
    done_button.click()
    time.sleep(1)

# 읽은 페이지수 0 선택 (기본값 그대로 완료)
def helper_select_zero_page(driver):
    button = driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value BEGINSWITH "0 / "`]'
    )
    button.click()
    time.sleep(1)

    done_button = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "완료"
    )
    done_button.click()
    time.sleep(1)

# 읽은 페이지수 휠을 한 칸(0 -> 1) 내려서 선택하고 완료한다.
def helper_select_one_page(driver):
    button = driver.find_element(
        AppiumBy.IOS_CLASS_CHAIN,
        '**/XCUIElementTypeTextField[`value BEGINSWITH "0 / "`]'
    )
    total_pages = button.get_attribute("value").split(" / ")[1]
    button.click()
    time.sleep(1)

    picker = driver.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePicker"
    )
    wheel = picker.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypePickerWheel"
    )

    driver.execute_script("mobile: selectPickerWheelValue", {
        "elementId": wheel.id,
        "order": "next"
    })

    done_button = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        "완료"
    )
    done_button.click()
    time.sleep(1)

    return total_pages

AIRPORT_DISPLAY_NAME = {
    "청주": "청주 (CJJ)",
    "리버풀": "리버풀 (LPL)",
}
# 공항 선택 헬퍼
def helper_select_airport(driver, keyword, airport: Airport):
    driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        f'버튼을 눌러 {airport.value}를 등록하세요'
    ).click()
    time.sleep(1)

    searchbar = driver.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypeTextField"
    )
    searchbar.send_keys(keyword + "\n")
    time.sleep(1)

    title = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        AIRPORT_DISPLAY_NAME[keyword]
    )

    title.click()
    time.sleep(1)
