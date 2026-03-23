# Flyleaf
> 독서를 여행처럼
<p align="center">
  <img src="Docs/Images/promotion.png" width="1000"/>
</p>



<p align="center">
  <img src="https://img.shields.io/badge/iOS-26.2+-pink.svg" />
  <img src="https://img.shields.io/badge/Xcode-26.2+-blue.svg" />
  <img src="https://img.shields.io/badge/Swift-6.2+-orange.svg" />
</p>

## 기술 스택
### iOS
- Swift 6.2
- iOS 26.2+
- UIKit

### Architecture
- Micro-Features Architecture(Modular Architecture)
- MVVM

### Tools
- Tuist
- Fastlane
- XCode 26.2

### Authentication
- Sign in with Apple

### Backend / Services
- Firebase (Auth, Firestore)

### UI / Design
- Figma
- Custom Design System
- Neutral Design System

### Dependency Management
- Tuist (SPM 기반)

### Test
- XCTest

## 프로젝트 시작하기
> **상세 가이드**: [INIT_GUIDE.md](Docs/INIT_GUIDE.md)
### 1. 필수 도구 설치
```bash
# Homebrew, mise, Tuist 설치
brew install mise
curl -Ls https://install.tuist.io | bash
```

### 2. 프로젝트 클론
```bash
git clone https://github.com/teamflyleaf/ios-flyleaf.git
cd ios-flyleaf
```

### 3. .env 설정 
`.env` 파일에는 인증 정보 및 민감한 값이 포함되어 있습니다.</br>
팀원에게 `.env` 파일을 직접 전달받아 프로젝트 루트에 추가해주세요.</br>
`.env` 파일은 보안을 위해 Git에 포함되지 않습니다.</br>

### 4. Firebase 설정
Firebase 사용을 위해 `GoogleService-Info.plist` 파일이 필요합니다.</br>
해당 파일은 보안상 Git에 포함되어 있지 않으므로, 팀원에게 전달받거나, 직접 콘솔에서 다운로드 받아 아래 경로에 추가해주세요.

- Dev: `Resources/Firebase/Dev/GoogleService-Info.plist`
- Prod: `Resources/Firebase/Prod/GoogleService-Info.plist`

### 5. 프로젝트 초기 설정
```bash
make init
```
`make init` 명령어는 프로젝트 초기 설정을 한 번에 수행합니다.
- tuist install -> Tuist 의존성을 설치합니다.
- make secrets-pull -> Notion에서 환경 설정 값을 가져와 Configs/*.xcconfig 파일을 생성합니다.
- tuist generate -> Xcode 프로젝트를 생성합니다.
- open Flyleaf.xcworkspace -> 생성된 워크스페이스를 실행합니다.
- Configs/*.xcconnfig 파일을 생성하려면 .env 파일에 NOTION_API_KEY와 NOTION_DATABASE_ID가 포함되어 있어야 합니다. 3번 과정을 정상적으로 완료했다면 별도의 추가 설정 없이 정상 동작합니다.

## 인증서 및 코드사인
> **상세 가이드**: [FASTLANE_GUIDE.md](Docs/FASTLANE_GUIDE.md)

Flyleaf는 `fastlane match`를 통해 인증서를 관리합니다.</br>
별도로 인증서를 수동으로 설치할 필요 없이, 배포 시 자동으로 인증서가 다운로드되고 Keychain에 설치됩니다.

```bash
make beta     # TestFlight 업로드 (인증서 자동 설치)
make release  # App Store 업로드 (인증서 자동 설치)
```

## 프로젝트 구조 및 아키텍처
> **상세 가이드**: [ARCHITECTURE_GUIDE.md](Docs/ARCHITECTURE_GUIDE.md)
### 1. Micro-Features Architecture
```
Root
├── Projects/
│   ├── App/              메인 앱 타겟 (앱 진입점)
│   ├── Core/             공통 비즈니스 로직 및 유틸리티 (도메인 모델, 서비스 등)
│   └── DesignSystem/     UI 컴포넌트 및 스타일 (에셋, 폰트, 컬러 등)
├── Features/
│   ├── Home/
│   │   ├── Feature/      Home 기능 구현 (실제 구현체 구현 ViewController, ViewModel 등)
│   │   ├── Interface/    외부에서 사용하는 인터페이스
│   │   ├── Tests/        Feature 테스트 코드
│   │   ├── Test/         테스트 유틸 또는 Mock
│   │   └── Example/      예제 앱 및 프리뷰 코드
│   ├── Login/
│   ├── Search/
│   └── …
```
Flyleaf 프로젝트는 Feature 중심의 Micro-Features Architecture를 기반으로 모듈을 구성했습니다.</br>
각 기능은 독립적인 Feature 단위로 분리되어 있으며, Feature 간 직접 의존하지 않고 Interface 모듈을 통해 의존성을 분리하는 구조를 사용하고 있습니다.</br>

**전체 의존성 방향**

<p align="center">
  <img src="Docs/Images/dependency-ex.png" width="1000"/>
</p>


### 2. Coordinator
<p align="center">
  <img src="Docs/Images/coordinator-flow.png" width="1000"/>
</p>

Flyleaf 프로젝트는 화면 전환 로직을 Coordinator 패턴을 통해 관리하고 있습니다.</br>
Coordinator는 어떤 화면을 보여줄지 결정하는 역할을 담당하고, 각 Feature는 자신의 화면을 생성하는 역할만 수행합니다.

### 3. MVVM
Flyleaf 프로젝트는 각 화면의 역할을 명확히 분리하기 위해 MVVM 패턴을 사용하고 있습니다.</br>
View는 UI를 구성하고 사용자 입력을 전달하는 역할을 담당합니다.</br>
ViewModel은 화면에 필요한 상태와 비즈니스 로직을 담당합니다.</br>
Model은 도메인 데이터와 서비스, 공통 로직을 담당합니다.

## 브랜치 전략
> **상세 가이드**: [BRANCH_STRATEGY_GUIDE.md](Docs/BRANCH_STRATEGY_GUIDE.md)
```
main (프로덕션)
↑
dev (개발 통합)
↑
feature/* (기능 개발)
```
### 워크 플로우
1. `feature/*` 브랜치에서 기능 단위로 개발을 진행합니다.
2. 개발이 완료되면 `dev` 브랜치로 Pull Request를 생성하여 병합합니다.
3. `dev` 브랜치에서 통합 및 테스트를 진행합니다.
4. 배포 시 `dev` -> `main` 브랜치로 병합하여 릴리즈합니다.
