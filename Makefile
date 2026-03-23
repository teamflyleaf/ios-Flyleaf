.PHONY: help init setup validate secrets-pull clean beta release feature

WORKSPACE=Flyleaf.xcworkspace

# -----------------------------
# 기본 도움말
# -----------------------------
help:
	@echo "🚀 Flyleaf Makefile 명령어 목록"
	@echo ""
	@echo "  make init                         - 프로젝트 초기 설정 (install → config → generate)"
	@echo "  make setup                        - 프로젝트 생성 및 실행"
	@echo "  make secrets-pull                 - Notion에서 xcconfig 설정을 가져옵니다"
	@echo "  make clean                        - 빌드 파일을 정리합니다"
	@echo "  make beta                         - TestFlight에 업로드합니다"
	@echo "  make release                      - App Store에 업로드합니다"
	@echo "  make feature name=XXX case=xxx    - 새로운 Feature를 생성합니다"

# -----------------------------
# 최초 셋업
# -----------------------------
init: validate
	@echo "Flyleaf 프로젝트 초기 설정 시작..."
	tuist install
	$(MAKE) secrets-pull
	tuist generate
	open $(WORKSPACE)

# -----------------------------
# 일반 개발용
# -----------------------------
setup: validate
	@echo "프로젝트 생성 중..."
	tuist generate
	open $(WORKSPACE)

# -----------------------------
# .env 확인
# -----------------------------
validate:
	@test -f .env || (echo "❌ .env 파일이 없습니다. .env.example을 복사하세요"; exit 1)
	@echo "✅ .env 확인 완료"

# -----------------------------
# Notion → xcconfig 생성
# -----------------------------
secrets-pull:
	@echo "🔄 Notion에서 설정을 가져오는 중..."
	@export $$(grep -v '^#' .env | xargs) && python3 scripts/pull_configs.py
	@echo "✅ xcconfig 생성 완료"

# -----------------------------
# 클린
# -----------------------------
clean:
	@echo "빌드 파일 정리 중..."
	rm -rf *.xcodeproj
	rm -rf *.xcworkspace
	rm -rf ~/Library/Developer/Xcode/DerivedData/Flyleaf-*

# -----------------------------
# Fastlane 배포
# -----------------------------
beta:
	@echo "TestFlight 업로드 중..."
	@export $$(grep -v '^#' .env | xargs) && fastlane ios beta

release:
	@echo "App Store 업로드 중..."
	@export $$(grep -v '^#' .env | xargs) && fastlane ios release

# -----------------------------
# Feature 생성
# -----------------------------
feature:
	@if [ -z "$(name)" ] || [ -z "$(case)" ]; then \
		echo "❌ name과 case를 모두 입력해야 합니다."; \
		echo "👉 예: make feature name=History case=history"; \
		exit 1; \
	fi
	@echo "Feature 생성 중: $(name)"
	tuist scaffold MicroFeature --name $(name) --case $(case)
