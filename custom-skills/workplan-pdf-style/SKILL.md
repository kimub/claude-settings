---
name: workplan-pdf-style
description: >
  작업계획서 PDF 변환 시 적용하는 디자인 가이드라인.
  컬러, 타이포그래피, 테이블, 코드 블록, callout 등 시각 사양을 정의.
  workplan-converter 에이전트가 참조하여 일관된 PDF를 생성한다.
globs:
  - "workplan/**/*.md"
---

# 작업계획서 PDF 디자인 가이드라인

이 스킬은 마크다운 작업계획서를 PDF로 변환할 때 적용하는 **디자인 사양**입니다.
모든 작업계획서 PDF에 동일하게 적용하여 일관성을 보장합니다.
이 사양은 절대 임의 변경하지 않습니다.

---

## 페이지 레이아웃

- 용지: A4 (595.28 x 841.89pt)
- 여백: 좌우 50pt, 상단 50pt, 하단 45pt
- 페이지 번호: 하단 중앙, "X / N" 형식, 9pt 회색(#888888)

---

## 컬러 팔레트

| 용도 | HEX | 설명 |
|------|-----|------|
| 테이블 헤더 배경 | #2D3748 | 다크 네이비/차콜 |
| 테이블 헤더 텍스트 | #FFFFFF | 흰색 |
| 테이블 바디 배경 | #FFFFFF | 흰색 |
| 테이블 테두리 | #D0D0D0 | 연한 회색 |
| 섹션 헤딩 (h2) | #1A202C | 거의 검정 |
| 서브섹션 헤딩 (h3) | #2B6CB0 | 파란/틸 색상 |
| 서브서브섹션 (h4) | #1A202C | 진한 검정 |
| 코드 블록 배경 | #F7F7F7 | 밝은 회색 |
| 코드 블록 테두리 | #E2E2E2 | 연한 회색 |
| 경고 callout 배경 | #FFF5F5 | 연한 핑크 |
| 경고 callout 보더 | #FC8181 | 빨간/핑크 |
| 정보 callout 배경 | #EBF8FF | 연한 파랑 |
| 정보 callout 보더 | #63B3ED | 파랑 |
| 가로 구분선 | #CBD5E0 | 중간 회색 |
| 본문 텍스트 | #1A202C | 진한 검정 |
| 인라인 코드 텍스트 | #C53030 | 진한 빨강 |
| 인라인 코드 배경 | #F0F0F0 | 밝은 회색 |

---

## 폰트 사양

- **기본 폰트**: AppleSDGothicNeo (macOS 기본 내장)
  - 경로: `/System/Library/Fonts/AppleSDGothicNeo.ttc`
  - Fallback: `/System/Library/Fonts/Supplemental/AppleGothic.ttf`
  - 추가 Fallback: Noto Sans CJK KR
- **모노스페이스 폰트**: Menlo 또는 Courier
  - 경로: `/System/Library/Fonts/Menlo.ttc`
  - Fallback: Courier

---

## 타이포그래피

| 요소 | 폰트 | 크기 | 행간 | 스타일 |
|------|------|------|------|--------|
| 문서 제목 (h1) | AppleSDGothicNeo-Bold | 20pt | 28pt | Bold |
| 섹션 헤딩 (h2) | AppleSDGothicNeo-Bold | 14pt | 22pt | Bold |
| 서브섹션 (h3) | AppleSDGothicNeo-Bold | 12pt | 18pt | Bold, 파란색 |
| 서브서브섹션 (h4) | AppleSDGothicNeo-Bold | 11pt | 16pt | Bold |
| 본문 | AppleSDGothicNeo | 9.5pt | 16pt | Regular |
| 테이블 헤더 | AppleSDGothicNeo-Bold | 9pt | 14pt | Bold, 흰색 |
| 테이블 본문 | AppleSDGothicNeo | 9pt | 14pt | Regular |
| 코드 블록 | Menlo | 8.5pt | 13pt | Regular |
| 인라인 코드 | Menlo | 8.5pt | - | Regular |
| 페이지 번호 | AppleSDGothicNeo | 9pt | - | Regular, 회색 |

---

## 테이블 스타일

- 헤더 행: 배경 #2D3748, 텍스트 흰색, Bold
- 바디 행: 배경 흰색, 텍스트 #1A202C
- 셀 패딩: 좌우 8pt, 상하 6pt
- 테두리: 전체 0.5pt #D0D0D0 실선
- 헤더 하단 테두리: 1pt #2D3748
- 테이블 상하 마진: 위 6pt, 아래 10pt
- 코드 값(버전, 상태 등)은 모노스페이스 폰트 사용

---

## 코드 블록 스타일

- 배경: #F7F7F7
- 테두리: 0.5pt #E2E2E2 (전체 박스)
- 내부 패딩: 좌우 12pt, 상하 10pt
- 폰트: Menlo 8.5pt
- 행간: 13pt
- 상하 마진: 위 6pt, 아래 10pt
- 최대 너비: 페이지 텍스트 영역 전체

---

## Callout 박스 (Blockquote) 스타일

마크다운의 `> ` 블록인용은 callout 박스로 렌더링합니다.
내용에 따라 두 가지 스타일을 구분합니다:

### 경고/중요 callout

키워드: "반드시", "필수", "주의", "중단", "핵심" 등 포함 시 (기본값)

- 왼쪽 보더: 4pt #FC8181 (빨간/핑크)
- 배경: #FFF5F5 (연한 핑크)
- 내부 패딩: 왼쪽 14pt (보더 포함), 우 12pt, 상하 10pt
- 폰트: 본문과 동일 9.5pt

### 정보 callout

키워드: "참고", "선택", "필요 시" 등 포함 시

- 왼쪽 보더: 4pt #63B3ED (파랑)
- 배경: #EBF8FF (연한 파랑)
- 내부 패딩: 왼쪽 14pt (보더 포함), 우 12pt, 상하 10pt
- 폰트: 본문과 동일 9.5pt

---

## 가로 구분선

마크다운의 `---`는 가로 구분선으로 렌더링:

- 색상: #CBD5E0
- 두께: 1pt
- 너비: 페이지 텍스트 영역 전체
- 상하 마진: 위 12pt, 아래 12pt

---

## Bold/Italic/인라인 코드

- **Bold**: `**text**` → AppleSDGothicNeo-Bold 동일 크기
- *Italic*: `*text*` → AppleSDGothicNeo 동일 크기 (기울임 시뮬레이션 또는 그대로)
- **인라인 코드**: `` `code` `` → Menlo 8.5pt, 배경 #F0F0F0, 텍스트 #C53030

---

## 불릿 목록

- 들여쓰기: 레벨 1 = 20pt, 레벨 2 = 40pt
- 불릿 기호: 레벨 1 = "•", 레벨 2 = "–"
- 불릿과 텍스트 간격: 8pt
- 항목 간 간격: 4pt

---

## 번호 목록

- 들여쓰기: 20pt
- 번호와 텍스트 간격: 8pt
- 항목 간 간격: 4pt

---

## 마크다운 → PDF 요소 매핑

| 마크다운 요소 | PDF 렌더링 |
|-------------|-----------|
| `# 제목` | 20pt Bold, 상단 제목, 아래 가로선 |
| `## 섹션` | 14pt Bold #1A202C, 위에 가로 구분선 |
| `### 서브섹션` | 12pt Bold #2B6CB0 |
| `#### 항목` | 11pt Bold #1A202C |
| 본문 텍스트 | 9.5pt Regular #1A202C, 행간 16pt |
| `**bold**` | Bold 동일 크기 |
| `` `inline code` `` | Menlo 8.5pt, 배경 #F0F0F0, 텍스트 #C53030 |
| 테이블 | 다크 헤더(#2D3748) + 흰색 바디, 회색 테두리 |
| 코드 블록 | 회색 배경(#F7F7F7), Menlo 8.5pt, 박스 테두리 |
| `> blockquote` | Callout 박스 (경고: 핑크, 정보: 파랑) |
| `---` | 가로 구분선 #CBD5E0, 1pt |
| 불릿 목록 | • 들여쓰기 20pt, 서브 – 40pt |
| 번호 목록 | 1. 들여쓰기 20pt |
| `[text](url)` | 파란색 텍스트 #2B6CB0, 밑줄 |

---

## reportlab 구현 힌트

PDF 변환 스크립트 작성 시 참고:

- 폰트 경로를 먼저 확인하고 사용 가능한 폰트를 자동 선택
- 테이블은 reportlab의 Table + TableStyle로 구현
- 코드 블록은 Preformatted 또는 배경이 있는 Table로 구현
- Callout 박스는 왼쪽 보더 + 배경색이 있는 Table로 구현
- 인라인 코드는 `<font>` 태그를 활용하여 모노스페이스 + 배경 처리
- 페이지 번호는 PageTemplate의 onPage 콜백으로 구현
- 가로 구분선(---): HRFlowable 또는 Drawing으로 구현
- 긴 테이블은 자동으로 페이지 분할 (repeatRows=1)
- 코드 블록 내 긴 줄은 적절히 줄바꿈
