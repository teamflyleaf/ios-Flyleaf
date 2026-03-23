#!/usr/bin/env python3
import os
import sys
from pathlib import Path

import requests


NOTION_API_KEY = os.getenv("NOTION_API_KEY")
NOTION_DATABASE_ID = os.getenv("NOTION_DATABASE_ID")

NOTION_VERSION = "2022-06-28"
NOTION_API_BASE = "https://api.notion.com/v1"

OUTPUT_DIR = Path("Configs")

ENV_TO_FILENAME = {
    "dev-debug": "DevDebug.xcconfig",
    "dev-release": "DevRelease.xcconfig",
    "prod-debug": "ProdDebug.xcconfig",
    "prod-release": "ProdRelease.xcconfig",
}


def fail(message: str) -> None:
    print(f"❌ 생성 실패: {message}", file=sys.stderr)
    sys.exit(1)


def validate_env() -> None:
    if not NOTION_API_KEY:
        fail("⚠️ NOTION_API_KEY가 설정되어 있지 않습니다.")
    if not NOTION_DATABASE_ID:
        fail("⚠️ NOTION_DATABASE_ID가 설정되어 있지 않습니다.")


def notion_headers() -> dict[str, str]:
    return {
        "Authorization": f"Bearer {NOTION_API_KEY}",
        "Notion-Version": NOTION_VERSION,
        "Content-Type": "application/json",
    }


def query_database() -> list[dict]:
    url = f"{NOTION_API_BASE}/databases/{NOTION_DATABASE_ID}/query"
    has_more = True
    next_cursor = None
    results: list[dict] = []

    while has_more:
        payload: dict[str, object] = {}
        if next_cursor:
            payload["start_cursor"] = next_cursor

        response = requests.post(
            url,
            headers=notion_headers(),
            json=payload,
            timeout=30,
        )

        if response.status_code != 200:
            fail(
                "⚠️ 노션 데이터베이스 조회 실패"
                f"({response.status_code}): {response.text}"
            )

        data = response.json()
        results.extend(data.get("results", []))
        has_more = data.get("has_more", False)
        next_cursor = data.get("next_cursor")

    return results


def get_title_value(prop: dict) -> str:
    items = prop.get("title", [])
    return "".join(item.get("plain_text", "") for item in items).strip()


def get_rich_text_value(prop: dict) -> str:
    items = prop.get("rich_text", [])
    return "".join(item.get("plain_text", "") for item in items).strip()


def get_select_value(prop: dict) -> str:
    select = prop.get("select")
    if not select:
        return ""
    return str(select.get("name", "")).strip()


def parse_row(row: dict) -> tuple[str, str, str]:
    props = row.get("properties", {})

    # Notion 기본 title 컬럼 이름은 보통 "Name" 또는 한국어면 "이름"일 수 있음.
    key_prop = props.get("Name") or props.get("이름")
    env_prop = props.get("Env")
    value_prop = props.get("Value")

    if key_prop is None:
        fail("⚠️ Title 컬럼(Name 또는 이름)을 찾을 수 없습니다.")
    if env_prop is None:
        fail("⚠️ Env 컬럼을 찾을 수 없습니다.")
    if value_prop is None:
        fail("⚠️ Value 컬럼을 찾을 수 없습니다.")

    key = get_title_value(key_prop)
    env = get_select_value(env_prop).lower()
    value = get_rich_text_value(value_prop)

    if not key:
        fail(f"⚠️ Key 값이 비어 있습니다. (row id: {row.get('id')})")
    if not env:
        fail(f"⚠️ '{key}'의 Env 값이 비어 있습니다.")
    if env not in ENV_TO_FILENAME:
        fail(
            f"⚠️ 지원하지 않는 Env '{env}' (Key: {key}) "
            f"⚠️ 가능 값: {', '.join(ENV_TO_FILENAME.keys())}"
        )
    if not value:
        fail(f"⚠️ '{key}'의 Value 값이 비어 있습니다. (env: {env})")

    return env, key, value


def build_config_map(rows: list[dict]) -> dict[str, dict[str, str]]:
    config_map: dict[str, dict[str, str]] = {
        env: {} for env in ENV_TO_FILENAME
    }

    for row in rows:
        env, key, value = parse_row(row)

        if key in config_map[env]:
            fail(f"⚠️ '{env}' 환경에서 중복된 Key 발견: {key}")

        config_map[env][key] = value

    return config_map


def write_xcconfig_files(config_map: dict[str, dict[str, str]]) -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    for env, filename in ENV_TO_FILENAME.items():
        path = OUTPUT_DIR / filename
        kv = config_map.get(env, {})

        if not kv:
            print(f"⚠️ '{env}' 환경에 값이 없습니다. 빈 파일을 생성합니다.")

        lines = [
            "// 자동 생성된 파일입니다.",
            "// 직접 수정하지 마세요.",
            "",
        ]

        for key in sorted(kv.keys()):
            lines.append(f"{key}={kv[key]}")

        lines.append("")

        path.write_text("\n".join(lines), encoding="utf-8")
        print(f"✅ 생성 완료: {path}")


def main() -> None:
    print("🔄 노션에서 xcconfig 설정을 가져오고 있어요.")
    validate_env()
    rows = query_database()
    config_map = build_config_map(rows)
    write_xcconfig_files(config_map)
    print("🎉 xcconfig 파일이 성공적으로 생성 됐어요.")


if __name__ == "__main__":
    main()
