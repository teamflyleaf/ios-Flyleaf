import requests

BASE_URL = "https://apis.yes24.com/v1"

# itemDetail GET 요청 테스트
def test_get_itemDetail(headers):
    response = requests.get(
        f"{BASE_URL}/goods/itemDetail",
        headers=headers,
        params={
            "query": "9788937460616",
            "searchType": "ISBN13",
            "detail": "Y"
        }
    )

    # GET 요청이 정상적으로 처리 되는지
    assert response.status_code == 200, f"GET 요청 실패: 상태 코드 = {response.status_code}, body = {response.text[:500]}"

# itemDetail 데이터 타입 일치 테스트
def test_get_itemDetail_data_type(headers):
    response = requests.get(
        f"{BASE_URL}/goods/itemDetail",
        headers=headers,
        params={
            "query": "9788937460616",
            "searchType": "ISBN13",
            "detail": "Y"
        }
    )

    body = response.json()

    data = body["data"]
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

        # 앱에서 pages가 null이면 missingItemPage 에러가 발생하므로 int여야 함
        pages = item.get("pages")
        assert isinstance(pages, int), f"items[{i}].pages 타입이 잘못 됨, 타입={type(pages).__name__}, 값={pages!r}"

        # 앱 DTO에서 contentDetail은 Optional이므로 null 허용
        content_detail = item.get("contentDetail")
        assert content_detail is None or isinstance(content_detail, dict), (
            f"items[{i}].contentDetail 타입이 잘못 됨, 타입={type(content_detail).__name__}, 값={content_detail!r}"
        )

        if content_detail is not None:
            introduction = content_detail.get("bookIntroduction")
            assert introduction is None or isinstance(introduction, str), (
                f"items[{i}].contentDetail.bookIntroduction 타입이 잘못 됨, "
                f"타입={type(introduction).__name__}, 값={introduction!r}"
            )
        
# itemDetail 검색 결과가 존재하지 않을 때
def test_get_itemDetail_empty(headers):
    response = requests.get(
        f"{BASE_URL}/goods/itemDetail",
        headers=headers,
        params={
            "query": "978893746asd1230616",
            "searchType": "ISBN13",
            "detail": "Y"
        }
    )

    body = response.json()

    # 검색 결과가 없을 때 404를 정상적으로 반환하는지
    statusCode = response.status_code
    assert statusCode == 404, f"상태 코드가 정상적이지 않음, statusCode={statusCode!r}"

    # 검색 결과가 없을 때 데이터가 null인지
    data = body["data"]
    assert data is None, f"검색 결과가 없지만 데이터가 존재함, data={data!r}"

    # 검색 결과가 없을 때 에러 코드가 정상적으로 GOODS_002인지
    errorCode = body["errorCode"]
    assert errorCode == "GOODS_002", f"에러코드가 정상적이지 않음, errorCode={errorCode!r}"


