from helpers.navigate_helper import navigate_to_history_tab
from history_tab.history_tab_helper import helper_has_history

import pytest

# 기록 탭 진입
@pytest.fixture
def history_tab_screen(driver):
    navigate_to_history_tab(driver)

    yield driver

# 기록 탭 진입 + 기록이 한 개 이상 존재하는 상태
@pytest.fixture
def history_tab_with_data(history_tab_screen):
    if not helper_has_history(history_tab_screen):
        pytest.skip("전제 조건 불충족: 기록이 없습니다. (테스트 계정에 기록 데이터 필요)")

    yield history_tab_screen
