# 유튜브 쇼츠 자동 제작기 (ShortsMaker) v1.9 Master Audio Fix

> 웹 브라우저 상에서 원클릭으로 9:16 세로형 유튜브 쇼츠(Shorts) 영상을 기획, 제작, 렌더링 및 다운로드하는 자동화 파이프라인 웹 애플리케이션입니다. 렌더링 시 배경음악(BGM), 전환 효과음(SFX), 사용자 나레이션 음원이 비디오 파일에 풍성하고 선명하게 결합되어 다운로드됩니다.

---

## 📌 프로젝트 개요
* **프로젝트명**: 유튜브 쇼츠 자동 제작기 (ShortsMaker)
* **저장소 위치**: `D:\92.SW\shorts`
* **로컬 접속 주소**: `http://localhost:5050`
* **실서버 배포 주소**: `https://wisekks-arch.github.io/shorts/index.html`
* **프롬프터 파일**: `쇼츠프롬프터.TXT` (UTF-8)

---

## 🚀 주요 기능 명세 (v1.9 Master Audio Fix 고도화)

### 1. 비디오 렌더링 마스터 오디오 스트림 합성 엔진 개선 - New!
* **BGM 무음 차단 버그 해결 (`isExporting = true`)**:
  * 렌더링 중에도 신스 배경음악 루프가 멈추지 않고 지속적으로 비디오 트랙에 공급되도록 연동
* **AudioContext 자동 재개 (`await audioCtx.resume()`)**:
  * 브라우저 오디오 일시중단(Suspended) 방지 및 활성화 보장
* **씬 전환 효과음(SFX) 실시간 믹싱**:
  * 비디오 녹화 중 씬이 바뀔 때 'Pop', 'Whoosh' 효과음이 Master Audio 버스에 함께 녹음
* **MediaRecorder 오디오 인코딩 최적화**:
  * `audioBitsPerSecond: 128000` 명시로 비디오와 오디오가 완벽히 싱크된 고음질 영상 추출

### 2. 음식점 전문 쇼츠 시나리오 2종 확충
* **🍽️ [신규 오픈] 우리 동네 화제의 신규 맛집 상륙! (오픈/장소안내)**:
  * 훅(Hook) ➔ 오픈 안내 ➔ 상세 위치/접근성 ➔ 인테리어/분위기 ➔ 오픈 이벤트 ➔ 행동 촉구(Call to Action)
* **🥩 [메뉴 소개] 육즙 폭발 시그니처 대표 메뉴 소개 (음식탐방)**:
  * 시선 집중 훅 ➔ 대표 메뉴 소개 ➔ 참숯 향/식감 디테일 ➔ 트러플 파스타 ➔ 신선 재료 ➔ 한정 수량 긴박감

### 3. 다운로드 경로 및 파일명 직접 지정 UI
* **저장 파일명 커스텀 및 3가지 저장 방식 선택 모달**:
  * 💻 **저장 폴더(경로) 직접 선택 (PC 권장)**: File System Access API(`showSaveFilePicker`)를 연동하여 Windows 파일 탐색기 저장 대화상자가 열리고 원하는 폴더 직접 지정
  * 📱 **휴대폰 저장 위치 / 앱 선택 (모바일 권장)**: Web Share API(`navigator.share`)를 연동하여 스마트폰의 '파일에 저장(내 파일 앱)', Google Drive 등 직접 선택
  * 📥 **기본 다운로드 폴더로 바로 저장**: 브라우저 기본 Downloads 폴더로 즉시 빠른 저장

### 4. 스마트폰 / PC 크로스 플랫폼 완벽 반응형 UI
* **모바일 최적화 레이아웃 (`@media (max-width: 960px)`)**:
  * 상단 플로팅 뷰 전환 탭(`[⚙️ 설정 및 편집] ↔ [📱 쇼츠 미리보기]`) 및 터치 최적화

### 5. 목표 동영상 플레이 시간 사전 세팅 (Duration Controller)
* **선택 옵션 6종**: 30초 / 1분 / 2분 / 3분 / 5분 / 자동

---

## 💻 로컬 실행 방법
1. 터미널(PowerShell) 실행
2. `d:\92.SW\shorts` 이동
3. `powershell -ExecutionPolicy Bypass -File server.ps1` 실행 또는 `start.bat` 더블 클릭
4. 브라우저에서 `http://localhost:5050` 접속
