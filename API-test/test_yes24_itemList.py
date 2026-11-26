import requests

BASE_URL = "https://apis.yes24.com/v1"

# itemList GET 요청 테스트
def test_get_itemList(headers):
    response = requests.get(
        f"{BASE_URL}/goods/itemList",
        headers=headers,
        params={
            "query": "설국",
            "category": "BOOK",
            "sort": "DEFAULT",
            "page": 1,
            "pageSize": 10,
            "detail": "N"
        }
    )

    # GET 요청이 정상적으로 처리 되는지
    assert response.status_code == 200, f"GET 요청 실패: 상태 코드 = {response.status_code}, body = {response.text[:500]}"

# itemList 데이터 타입 일치 테스트
def test_get_itemList_data_type(headers):
    response = requests.get(
        f"{BASE_URL}/goods/itemList",
        headers=headers,
        params={
            "query": "설국",
            "category": "BOOK",
            "sort": "DEFAULT",
            "page": 1,
            "pageSize": 10,
            "detail": "N"
        }
    )

    data = response.json()["data"]
    assert data, "검색 결과가 없음"
    items = data["items"]
    assert isinstance(items, list), "아이템이 비어있음"

    for i, item in enumerate(items):
        title = item["title"]
        assert isinstance(title, str), f"items[{i}].title 타입이 잘못 됨, 타입={type(title).__name__}, 값={title!r}"

        author = item["author"]
        assert isinstance(author, str), f"items[{i}].author 타입이 잘못 됨, 타입={type(author).__name__}, 값={author!r}"

        cover = item["cover"]
        assert isinstance(cover, str), f"items[{i}].coverURL 타입이 잘못 됨, 타입={type(cover).__name__}, 값={cover!r}"

        publisher = item["publisher"]
        assert isinstance(publisher, str), f"items[{i}].publisher 타입이 잘못 됨, 타입={type(publisher).__name__}, 값={publisher!r}"

        isbn13 = item["isbn13"]
        assert isinstance(isbn13, str), f"items[{i}].isbn13 타입이 잘못 됨, 타입={type(isbn13).__name__}, 값={isbn13!r}"

# itemList 검색 결과가 존재하지 않을 때
def test_get_itemList_empty(headers):
    response = requests.get(
        f"{BASE_URL}/goods/itemList",
        headers=headers,
        params={
            "query": "ㄴ;ㅣ암;ㅣ나122ㅐㅔ3120-3123ㅏㅣ;암",
            "category": "BOOK",
            "sort": "DEFAULT",
            "page": 1,
            "pageSize": 10,
            "detail": "N"
        }
    )

    body = response.json()

    # 검색 결과가 없을 때 404를 정상적으로 반환하는지
    statusCode = response.status_code
    assert statusCode == 404, f"상태 코드가 정상적이지 않음, statusCode={statusCode!r}"

    # 검색 결과가 없을 때 데이터가 null인지
    data = body["data"]
    assert data is None, f"검색 결과가 없지만 데이터가 존재함, data={data!r}"

    # 검색 결과가 없을 때 에러 코드가 정상적으로 SEARCH_001인지
    errorCode = body["errorCode"]
    assert errorCode == "SEARCH_001", f"에러코드가 정상적이지 않음, errorCode={errorCode!r}"


