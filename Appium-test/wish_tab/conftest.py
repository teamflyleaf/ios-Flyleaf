from helpers.navigate_helper import navigate_to_wishlist_tab
from wish_tab.wish_tab_helper import helper_has_wish

import pytest

# 예약 탭 진입 + 예약이 한 개 이상 존재하는 상태
@pytest.fixture
def wish_tab_with_data(driver):
    navigate_to_wishlist_tab(driver)

    if not helper_has_wish(driver):
        pytest.skip("전제 조건 불충족: 예약이 없습니다. (테스트 계정에 예약 데이터 필요)")

    yield driver
