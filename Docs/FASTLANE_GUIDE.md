# Flyleaf Fastlane 가이드

Flyleaf는 `fastlane`을 사용하여 iOS 배포 과정을 자동화하고 있습니다.
인증서 및 프로비저닝 파일은 `match`로 관리하며, TestFlight 및 App Store 업로드를 각각 lane으로 분리해 운영합니다.

---

## 목차
1. [개요](#1-개요)
2. [구성 요소](#2-구성-요소)
3. [사전 준비](#3-사전-준비)
4. [환경 변수](#4-환경-변수)
5. [주요 명령어](#5-주요-명령어)
6. [배포 흐름](#6-배포-흐름)
7. [인증서 및 match](#7-인증서-및-match)
8. [문제 해결](#8-문제-해결)

---

## 1. 개요

Flyleaf는 다음 두 가지 배포 흐름을 사용합니다.

- **beta**: `FlyleafDev` 스킴을 빌드하여 TestFlight에 업로드
- **release**: `Flyleaf` 스킴을 빌드하여 App Store Connect에 업로드

이를 통해 개발/검증 환경과 실제 배포 환경을 분리합니다.

---

## 2. 구성 요소

Flyleaf의 배포 자동화는 아래 구성으로 이루어져 있습니다.

- **Fastfile**  
  실제 배포 lane 정의
- **Matchfile**  
  인증서 / 프로비저닝 프로파일 저장소 설정
- **Appfile**  
  앱 식별자 및 Apple 계정 관련 설정
- **.env**  
  민감한 배포 정보 및 환경 변수
- **fastlane match**  
  인증서 및 프로파일 자동 설치
- **Tuist**  
  프로젝트 생성 및 모듈 구성

---

## 3. 사전 준비

Fastlane 배포 전 아래 항목이 준비되어 있어야 합니다.

### 필수 준비 항목

- `.env` 파일
- App Store Connect API Key (`.p8`)
- `GoogleService-Info.plist`
- `fastlane-certificates` 저장소 접근 권한
- Apple Developer Team 권한

### Fastlane 설치
**명령어**
```bash
brew install fastlane
```
**설치 확인**
```bash
fastlane --version
```
### App Store Connect API key (.p8
Flyeleaf는 App Store Connect 인증을 위해 API Key 기반 인증 방식을 사용합니다.

필요한 파일
- AuthKey_XXXXXX.p8

**설정 방법**
1. 팀원에게 .p8 파일을 전달받습니다.
2. 아래 경로에 파일을 위치시킵니다.

```
ios-flyleaf/
├── fastlane/
│   └── AuthKey_XXXXXX.p8
```

**.p8 파일은 매우 민감한 정보이므로 Git에 포함되지 않습니다.**

---

## 4. 환경 변수
.env 파일에는 배포에 필요한 민감한 값이 포함되어 있습니다.
```bash
# App Store Connect API Key
APP_STORE_CONNECT_KEY_ID=
APP_STORE_CONNECT_ISSUER_ID=
APP_STORE_CONNECT_KEY_FILEPATH=./fastlane/AuthKey_XXXXXX.p8

# fastlane match
MATCH_GIT_URL=

# Apple account
FASTLANE_USER=

# App identifiers
APP_IDENTIFIER_DEV=com.yeo.flyleaf.dev
APP_IDENTIFIER_PROD=com.yeo.flyleaf

# Team
APP_STORE_TEAM_ID=
```

**.env 파일은 보안을 위해 Git에 포함되지 않습니다.**

---

## 5. 주요 명령어
Flyleaf는 Makefile을 통해 fastlane 실행을 단순화 합니다.

**TestFlight 업로드**
```bash
make beta
```

**AppStore 업로드**
```bash
make release
```

---

## 6. 배포 흐름

**TestFlight 배포**

beta lane은 다음 순서로 동작합니다.
1. App Store Connect API Key 로드
2. match(type: "appstore") 실행
3. FlyleafDev 스킴 Release 빌드
4. IPA 생성
5. TestFlight 업로드

실행 명령
```bash
make beta (권장)
fastlane ios beta (패스트레인 직접 명령어)
```

사용 시점
- dev 브랜치에서 통합 테스트 후
- 내부 QA 및 기능 확인이 필요할 때

**App Store 배포**

release lane은 다음 순서로 동작합니다.
1. App Store Connect API Key 로드
2. match(type: "appstore") 실행
3. Flyleaf 스킴 Release 빌드
4. IPA 생성
5. App Store Connect 업로드

실행 명령
```bash
make release (권장)
fastlane ios release (패스트레인 직접 명령어)
```

사용 시점
- main 브랜치 기준 배포 시점
- 릴리즈용 빌드를 업로드할 때

---

## 7. 인증서 및 match
Flyleaf는 fastlane match를 사용하여 인증서를 관리합니다.

**인증서 저장소**
```
flyleaf-certificates
```

**동작 방식**
배포 시 match가 자동으로:
- 인증서 다운로드
- 프로비저닝 프로파일 다운로드
- macOS Keychain 설치

를 수행합니다.

즉, 팀원이 수동으로 인증서를 설치할 필요는 없습니다.

**최초 실행 시**
최초 배포 시 다음 동작이 발생할 수 있습니다.
- Apple 계정 인증 요청
- Keychain 접근 권한 요청
- 인증서 저장소 접근 권한 확인

**flyleaf-certificates 저장소 접근 권한이 없으면 match가 실패합니다.**

---

## 8. 문제 해결
**1. 인증서 저장소 clone 실패**
```
Permission denied (publickey)
fatal: Could not read from remote repository.
```
인증서 저장소 접근 권한 없는 경우:
- flyleaf-certificates 저장소 권한 요청
- GitHub 로그인 상태 확인

**2. provisioning profile 관련 오류**
```
Provisioning profile ... doesn't include signing certificate ...
```
signing 설정 불일치 및 development/distribution 인증서 혼용 시:
- match development 명령어 실행
- match appstore 명령어 실행

**3. App Store Connect 업로드 실패**
```
Couldn't find app 'com.yeo.flyleaf.dev'
```
App Store Connect에 업로드 실패 시:
- App Store Connect에 앱 생성 여부 확인
- APP_IDENTIFIER_DEV, APP_IDENTIFIER_PROD 확인

**4. 네트워크 업로드 실패**
```
The network connection was lost. (-1005)
```
네트워크 이슈 발생 시:
- 일시적인 업로드 네트워크 이슈이므로 동일 명령 재시도
- VPN/네트워크 상태 확인

---

## 정리
- 인증서는 match가 자동 설치
- env와 .p8 파일 필요
- flyleaf-certificates 접근 권한 필요
- dev는 TestFlight, main은 App Store 배포 기준