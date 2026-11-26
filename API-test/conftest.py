# 환경 변수를 읽기 위해 os import
import os 
from pathlib import Path

import pytest
from dotenv import load_dotenv

# 스크립트 파일을 기준으로 .env 파일을 찾아서, 어느 폴더에서 실행해도 동작함
load_dotenv(Path(__file__).resolve().parent / ".env")

# Log에 API-key가 노출될 수 있기 때문에 마스킹
class MaskedHeaders(dict):
    def __repr__(self):
        return "{'X-Api-Key': '***'}"
    
# 헤더 셋업 메소드
@pytest.fixture
def headers():
    api_key = os.getenv("YES24_API_KEY")
    if not api_key:
        pytest.fail("YES24_API_KEY가 존재하지 않습니다.")
    return MaskedHeaders({"X-Api-Key": api_key})
