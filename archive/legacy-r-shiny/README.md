# 아카이브 — 레거시 R Shiny 앱 (2026-07-06)

빛스탯 HS가 **Quarto × shinylive-python(Pyodide)** 사이트로 전환되면서
보관용으로 이동한 초기 R Shiny 코드입니다. 현재 사이트에서는 사용되지 않습니다.

| 항목 | 내용 |
|---|---|
| `app.R`, `global.R` | gridlayout 기반 학생용 화면 — hsData 데이터셋 선택 → gt 표 → 변수 끌어놓기 → 요약통계·GGally 시각화 |
| `R/` | 홈(교육과정 카드)·학생용·교수용 화면 함수 |
| `01_ui_editor/` | shinyuieditor 산출물 (ui.R / server.R) |
| `02_module/` | 교육과정 카드 화면의 Shiny 모듈화 실험 |
| `03_app/` | 단일 파일 앱 실험 |
| `rsconnect/` | shinyapps.io 배포 설정 |
| `www/` | 교과서 표지 이미지 (중1–고3, 확률과 통계, 통계와 사회) |

## 참조 가치

- `app.R`의 **hsData 탐색기 로직**(데이터 선택 → 상세정보 → 변수 버킷 → 요약·시각화)은
  현재 `pages/05_society/explorer/`가 예시 데이터로 단순화해 계승한 원형입니다.
  실제 hsData 패키지 데이터를 쓰는 탐색기를 만들 때 이 코드를 참조하세요
  (hsData는 R 패키지이므로 CSV/parquet 변환이 필요합니다).
- `www/`의 교과서 표지 이미지는 홈이나 문서에서 교육과정 안내용으로 재사용할 수 있습니다.

완전히 불필요해지면 이 폴더째 삭제하면 됩니다 — git 이력에는 남습니다.
