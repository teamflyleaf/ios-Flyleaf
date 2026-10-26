from appium.webdriver.common.appiumby import AppiumBy

import time

# 검색 플로우 헬퍼 (서치바 attribute에 접근하기 위해 서치바 반환)
def helper_airport_search_flow(driver, keyword):
    searchbar = driver.find_element(
        AppiumBy.CLASS_NAME,
        "XCUIElementTypeTextField"
    )

    searchbar.send_keys(keyword + "\n")
    time.sleep(1)

    return searchbar
