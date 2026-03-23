# Flyleaf 브랜치 전략 가이드

Flyleaf는 기능 개발, 통합 테스트, 배포 단계를 명확히 분리하기 위해  
`feature -> dev -> main` 구조의 브랜치 전략을 사용합니다.

---

## 📋 목차

1. [브랜치 구조](#1-브랜치-구조)
2. [브랜치 역할](#2-브랜치-역할)
3. [워크플로우](#3-워크플로우)
4. [작업 시작 방법](#4-작업-시작-방법)
5. [PR 및 머지 규칙](#5-PR-및-머지-규칙)
6. [배포 전략](#6-배포-전략)
7. [Hotfix 전략](#7-Hotfix-전략)
8. [브랜치 네이밍 규칙](#8-브랜치-네이밍-규칙)

---

## 1. 브랜치 구조

```
main (프로덕션)
  ↑
dev (개발 통합 / 테스트)
  ↑
feature/* (기능 개발)
```

---

## 2. 브랜치 역할

### main
- 실제 배포 기준 브랜치
- 항상 안정 상태 유지
- App Store 배포 기준

### dev
- 기능 통합 및 테스트 브랜치
- TestFlight 검증
- feature 브랜치들이 먼저 병합되는 브랜치

### feature/*
- 기능 개발 브랜치
- 작업 단위로 분리하여 생성

---

## 3. 워크플로우

```
feature/* -> dev -> main
```

### 흐름

1. dev 기준으로 feature 브랜치 생성
2. 기능 개발 진행
3. dev로 PR 생성
4. 코드 리뷰 및 머지
5. TestFlight 검증
6. main으로 머지 후 배포

---

## 4. 작업 시작 방법

```bash
git checkout dev
git pull origin dev
git checkout -b feature/32-history
```

작업 완료 후:

```bash
git push origin feature/32-history
```

---

## 5. PR 및 머지 규칙

- feature -> dev만 허용
- main 직접 머지 금지
- Squash Merge 권장

---

## 6. 배포 전략

### TestFlight (dev 기준)

```bash
make beta
```

### App Store (main 기준)

```bash
make release
```

---

## 7. Hotfix 전략

```
hotfix/* → main
         ↘ dev
```

### 흐름

1. main 기준으로 hotfix 생성
2. 수정 후 main에 반영
3. 동일 변경사항 dev에도 반영

---

## 8. 브랜치 네이밍 규칙

### Feature
```
feature/이슈번호-기능명
```

예:
- feature/32-history

### Hotfix
```
hotfix/41-hotfixBug
```

### Docs
```
docs/31-guide
```