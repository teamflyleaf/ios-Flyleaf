# Flyleaf 프로젝트 세팅 가이드

`git clone` 이후 별도의 복잡한 설정 없이 바로 실행할 수 있도록 구성된 온보딩 가이드입니다.

---

## 목차
1. [필수 도구 설치](#1-필수-도구-설치)
2. [프로젝트 클론](#2-프로젝트-클론)
3. [.env 설정](#3-env-설정)
4. [Firebase 설정](#4-firebase-설정)
5. [프로젝트 초기 설정](#5-프로젝트-초기-설정)
6. [문제 해결](#6-문제-해결)

---

## 1. 필수 도구 설치
### mise 설치 (권장)
Flyleaf는 개발 환경 관리를 위해 mise를 사용합니다.<br>
**설치 명령어**
```bash
brew install mise
```
**설치 확인**
```bash
mise --version
```

### Tuist 설치
**설치 명령어**
```bash
curl -Ls https://install.tuist.io | bash
```
**설치 확인**
```bash
tuist version
```

## 2. 프로젝트 클론
```bash
git clone https://github.com/teamflyleaf/ios-flyleaf.git
cd ios-flyleaf
```

## 3. .env 설정
.env 파일에는 인증 정보 및 민감한 값이 포함되어 있습니다.</br>
팀원에게 .env 파일을 전달받아 프로젝트 루트에 추가해주세요.</br>
```
ios-flyleaf/
├── .env <- 여기에 추가
├── Makefile
├── Projects/
├── Features/
└── ...
```
.env 파일은 보안을 위해 Git에 포함되지 않습니다.

**.env에 포함되어 있는 주요 값**
```
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_KEY_FILEPATH
MATCH_GIT_URL
FASTLANE_USER
APP_IDENTIFIER_DEV
APP_IDENTIFIER_PROD
APP_STORE_TEAM_ID
NOTION_API_KEY
NOTION_DATABASE_ID
```

### 4. Firebase 설정
Firebase 기능을 사용하기 위해 설정 파일이 필요합니다.</br>
GoogleService-Info.plist 파일을 팀원에게 전달받아 아래 경로에 추가해주세요. </br>
```
Resources/Firebase/Dev/GoogleService-Info.plist
Resources/Firebase/Prod/GoogleService-Info.plist

ios-flyleaf/
├── Resources/
│   └── Firebase/
│       ├── Dev/
│       │   └── GoogleService-Info.plist <- dev 환경
│       └── Prod/
│           └── GoogleService-Info.plist <- prod 환경
```
GoogleService-Info.plist 파일은 보안을 위해 Git에 포함되지 않습니다.

### 5. 프로젝트 초기 설정
```bash
make init
```
make init 명령어는 프로젝트 실행에 필요한 초기 설정을 한 번에 수행합니다.

**수행 작업**
- tuist install
-> Tuist 의존성을 설치합니다.
- make secrets-pull
-> Notion 환경에서 설정 값을 가져와 Configs/*.xcconfig 파일을 생성합니다.
- tuist generate
-> Xcode 프로젝트를 생성합니다.
- open Flyleaf.xcworkspace
-> 생성된 워크스페이스를 실행합니다.

Configs/*.xcconfig 파일 생성을 위해 .env에 NOTION_API_KEY와 NOTION_DATABASE_ID가 포함되어 있어야 합니다. 3번 과정을 정상적으로 완료했다면 추가 설정 없이 동작합니다.

### 6. 문제 해결
**1. .env file not found**</br>
`make init` 실행 시 .env 파일이 없다는 오류가 발생하면:
- .env 파일이 프로젝트 루트에 존재하는지 확인
- 팀원에게 .env 파일 재요청


**2. Notion API 오류(403)**</br>
Notion integration이 DB에 연결되지 않은 경우:
- Notion DB -> Share -> integration 추가


**3. xcconfig 생성 실패**</br>
`make secrets-pull` 실행 시 xcconfig 생성 실패 오류가 발생하면:
- .env에 NOTION_API_KEY 설정 여부 확인
- NOTION_DATABASE_ID 값 확인
- Notion DB 컬럼 구조 (Name, Env, Value) 확인


**4. Firebase 관련 오류**</br>
GoogleService-Info.plist 누락 오류가 발생하면:
- Firebase 설정 파일이 올바른 경로에 있는지 확인

---

## 정리
```bash
git clone https://github.com/teamflyleaf/ios-flyleaf.git
cd ios-flyleaf

# .env 파일 추가
# Firebase plist 추가

make init
```
위 과정만 완료하면 바로 프로젝트 실행이 가능합니다.