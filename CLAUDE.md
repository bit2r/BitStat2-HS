# CLAUDE.md — 빛스탯 HS 개발 규약

고교 통계 학습 사이트. **Quarto website + shinylive-python**(Pyodide, 브라우저에서
파이썬 실행). 렌더 산출물 `docs/`는 gh-pages로 배포(gitignore).

## 모듈 구조

각 개념 = `pages/NN_unit/slug/index.qmd` 한 파일. 고정 템플릿:

```
---
title: "..."
---
::: {.hs-back} [← 빛스탯 HS 홈](../../../index.qmd) :::
::: {.hs-meta} 단원 NN ... · 「확률과 통계」 · ... :::
## 개념            (설명 + $수식$ + ::: {.column-margin} 여백 노트)
## 만지며 배우기    ::: {.panel-tabset} ### 인터랙티브 앱 / ### 파이썬 코드 :::
## 스스로 확인      ::: {.callout-tip collapse="true" title="..."} ... :::  (2개)
::: {.hs-prevnext} [← 이전]() [다음 →]() :::
```

- 인터랙티브 앱은 ` ```{shinylive-python} ` 블록(`#| standalone: true`).
- 새 모듈 추가 시: `index.qmd`의 교육과정 지도에 링크 추가, 모듈 수 갱신,
  인접 모듈의 `.hs-prevnext` 이전/다음 연결.

## ⚠️ 차트 규약 — matplotlib 금지, 인라인 SVG 사용

**shinylive 앱의 그래프는 matplotlib이 아니라 파이썬 인라인 SVG 문자열로 그린다.**
`output_ui` + `ui.HTML(svg_string)` 로 렌더한다. 이유:

1. **성능** — matplotlib 스택(matplotlib+contourpy+pillow+fonttools+kiwisolver…)은
   약 9.4 MB, numpy 2.9 MB. 제거하면 앱 첫 방문 페이로드가 **34.9 MB → 22.6 MB
   (−35%)** 로 준다(브라우저 실측). import·폰트 캐시 구축 시간이 사라져 **초기화도
   단축**된다.
2. **한글** — Pyodide matplotlib에는 한글 폰트가 없어 축·라벨이 □로 깨진다.
   SVG `<text>`는 브라우저 폰트를 써서 한글이 정상 표시된다.

### 규칙
- `import matplotlib` / `import numpy` **금지**. 통계 계산은 표준 라이브러리로:
  `statistics`(mean/median/pstdev), `math`(comb/erf/sqrt), `collections.Counter`,
  `fractions`, `random`(시뮬레이션). 사다리꼴 적분·집계는 순수 파이썬 루프.
- 차트는 `viewBox` 기반 SVG를 f-string으로 조립하고 `style="width:100%;height:auto"`
  로 반응형. 좌표는 데이터→px 매핑 함수(`X(v)`, `Y(v)`)로.
- 색: ACCENT `#2563eb`, INK `#111827`, MUTED `#6b7280`, GRID `#e5e7eb`.
- 아키타입별 SVG 요소: 막대=`<rect>`, 점=`<circle>`, 선/곡선=`<path d="M..L..">`,
  음영=닫힌 `<path ... Z>` + `opacity`, 축 라벨=`<text>`.
- 참고 구현(모범): `01_data/freq_table`(히스토그램 막대), `01_data/center`(점+대푯값선),
  `03_dist/continuous_rv`(밀도곡선+음영), `01_data/data_info`·`structure`(HTML 막대/표).
- 「파이썬 코드」 탭도 numpy 대신 stdlib 예시로 맞춘다.

## 렌더 / 검증

이 저장소의 커밋된 `.venv/`는 다른 사용자 경로라 이 머신에서 깨져 있다. 격리 venv로 렌더:

```bash
python3 -m venv rvenv && rvenv/bin/pip install pyyaml jupyter shinylive
export QUARTO_PYTHON=<rvenv>/bin/python
export PATH=<rvenv>/bin:$PATH      # shinylive.lua가 PATH의 shinylive 실행파일 호출
quarto render pages/<u>/<m>/index.qmd   # 한 번에 하나씩(동시 렌더 시 경로 충돌)
```

- 렌더 전 빠른 검증: homebrew `python3`로 `ast.parse` + 앱 계산 로직 직접 실행.
- 전환 검증 지표(브라우저): DevTools/Playwright로 pyodide 요청이 `openssl`에서 끝나면
  (matplotlib·numpy 미로드) 성공. `no-store`인 localhost는 다운로드가 즉시라 성능 판단은
  스로틀/배포에서.
- 관련 문서: `shinylive-performance-review.md`, `shinylive-caching-review.md`,
  `images/shinylive-*.svg`.
