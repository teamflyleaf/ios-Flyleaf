from helpers.navigate_helper import navigate_to_journey_tab
from journey_tab.journey_tab_helper import helper_has_journey

import pytest

# 여행 탭 진입 
@pytest.fixture
def journey_tab_screen(driver):
    navigate_to_journey_tab(driver)

    yield driver

# 여행 탭 진입 + 진행 중인 여행이 한 개 이상 존재하는 상태
@pytest.fixture
def journey_tab_with_data(journey_tab_screen):
    if not helper_has_journey(journey_tab_screen):
        pytest.skip("전제 조건 불충족: 진행 중인 여행이 없습니다. (테스트 계정에 여행 데이터 필요)")

    yield journey_tab_screen
