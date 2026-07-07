# 빛스탯 HS (BitStat2-HS)

고교 통계, 만지며 배운다 — 고등학생용 오픈 통계 학습 사이트.

슬라이더를 움직이면 그래프가 답합니다. 교과서 순서 그대로, 설치도 계정도 없이
브라우저에서 — 파이썬(Pyodide)이 브라우저 안에서 직접 돌아갑니다.

## 구성

- **5개 단원 · 25개 모듈** — 인터랙티브 앱 24 + 탐구 안내 1 (핵심 3개 단원은 2022 개정 「확률과 통계」 정렬)
  1. 자료와 그래프 — 중등 복습·진단 (6)
  2. 경우의 수와 확률 — 「확률과 통계」 (7)
  3. 확률분포 — 「확률과 통계」 (4)
  4. 통계적 추정 — 「확률과 통계」 (4)
  5. 통계와 사회 — 실생활 데이터·수행평가 (4)
- 모듈 공통 구조: 개념 → 인터랙티브 앱(Shiny for Python × shinylive) + 파이썬 코드 탭 → 스스로 확인

## 기술 스택

- Quarto website + [quarto-ext/shinylive](https://github.com/quarto-ext/shinylive) + Pyodide (서버리스)
- 앱 의존성: numpy + matplotlib만 사용 (로딩 속도 우선 — scipy·pandas 배제)
- 렌더: `quarto render` → `docs/` (gitignore, gh-pages 배포)

## 개발

```bash
pip install shinylive          # quarto 확장이 요구
quarto render
python3 -m http.server 8734 -d docs   # 로컬 확인
```

UI 설계도(Tufte 스타일 SVG): `images/2026-07-06_hs_*.svg`
레거시 R Shiny 코드: `archive/legacy-r-shiny/` (참조용 보관)

제작: 한국 R 사용자회 · 콘텐츠 CC BY-NC-SA 4.0 · 코드 GPL-3.0
