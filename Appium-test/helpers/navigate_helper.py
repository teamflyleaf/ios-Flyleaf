from appium.webdriver.common.appiumby import AppiumBy
import time

# 범용 탭 이동 메소드
def navigate_to_tab(driver, tab_name):
    tab = driver.find_element(
        AppiumBy.ACCESSIBILITY_ID,
        tab_name
    )
    tab.click()
    time.sleep(2)

# 홈화면 네비게이트
def navigate_to_home_tab(driver):
    navigate_to_tab(
        driver, 
        "홈"
    )

# 여행화면 네비게이트
def navigate_to_journey_tab(driver):
    navigate_to_tab(
        driver,
        "여행"
    )

# 예약화면 네비게이트
def navigate_to_wishlist_tab(driver):
    navigate_to_tab(
        driver,
        "예약"
    )

# 기록화면 네비게이트
def navigate_to_history_tab(driver):
    navigate_to_tab(
        driver,
        "기록"
    )

# 설정화면 네비게이트
def navigate_to_settings(driver):
    navigate_to_tab(
        driver,
        "settings"
    )
