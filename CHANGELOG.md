# Changelog

## 0.2.0

토큰과 테마 빌더 — 톤 하나로 앱 전체 `ThemeData` 를 만든다.

- `ATone`(brand · primary · primaryPressed · ink) + `ATone.fromBrand` — 흰 글자 4.5:1 을 만족하도록 버튼색 · 글자색 계산.
- `ANeutrals`(차가운 중립 회색 light/dark) · `ASemanticColors`(positive · negative · warning) · `ARadii` · `ASpacing` · `AMotion` · `aTextTheme`.
- `AThemeData`(ThemeExtension — 면 · 브랜드 · 의미색 · 토큰, `of(context)` 는 확장이 없어도 동작).
- `AThemeBuilder.light/dark` — `ColorScheme` 의 모든 역할을 채우고 표준 위젯 컴포넌트 테마(AppBar · 입력 · 버튼 · 카드 · 시트 · 다이얼로그 · 스낵바 · 진행 · 메뉴 · 검색 · 레일 · 툴팁)를 맞춘다.
- `contrastRatio` · `darkenToContrast`.
- 갤러리: 톤 · 다크 전환과 표준 위젯 견본.

## 0.1.0

새 디자인 시스템(1.0.0)을 만들기 위한 구조 정리. 위젯 동작은 바뀌지 않았다.

- **Breaking:** 옛 위젯을 `package:flutter_artis_ui_kit/legacy.dart` 로 옮겼다.
  `package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart` 는 새 디자인 시스템의 공개 API 자리이며 아직 비어 있다.
- 패키지 구조 `lib/src/…`, 린트(`flutter_lints` + `public_member_api_docs`), CI, 갤러리 예제 앱 뼈대, MIT 라이선스.
- 의존 방식: git 태그 + 로컬 개발용 `pubspec_overrides.yaml`.

## 0.0.1

- 최초 위젯: `AButton` · `ACard` · `ACardButton` · `AWell` · `ATextFormField` · `APopupMenuButton` · `ABottomNavigationBar` · `ASampleText`.
