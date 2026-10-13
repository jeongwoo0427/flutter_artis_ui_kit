# Changelog

## 2.1.0

- `AListRow`: 잉크 · 선택 면이 콘텐츠보다 좌우로 `spacing.md` 만큼 넓게 번지고(콘텐츠 자리는 그대로), 행마다 위아래 2 의 틈을 둬서 이어서 선택한 행이 한 덩어리로 붙지 않는다. 행 높이는 그대로(최소 56).
- `AAdaptiveNavigation.navigationVisible`: `false` 면 좁은 창의 하단 탭이 아래로 미끄러져 숨는다(선택 모드에서 그 자리에 다른 바를 올릴 때).

## 2.0.0

- **깨지는 변경:** 1.0 이전 옛 위젯(`legacy.dart` — 옛 `AButton` · `ACard` · `ACardButton` · `AWell` · `ATextFormField` · `APopupMenuButton` · `ABottomNavigationBar` · `ASampleText`)을 삭제했다.
  옮기는 방법은 `doc/migration_from_legacy.md`.
- `AThemeBuilder` 가 `SegmentedButton` 도 맞춘다 — 고른 칸 = 연한 primary(`primaryContainer`), 나머지 = 투명 + 보조 글자색.
  M3 기본(`secondaryContainer`)은 회색 면과 거의 같아 카드 · 시트 위에서 고른 칸이 보이지 않았다.

## 1.0.0

새 디자인 시스템의 첫 안정판 — 테마 빌더(0.2.0) 위에 컴포넌트 24개.

- **버튼 · 면 · 목록:** `AButton`(+`.tonal` `.neutral` `.danger` `.text`, `AButtonSize`, `isLoading`) · `ACard` · `ASectionCard` · `ASectionHeader` ·
  `AListRow` · `AKeyValueRow` · `AStatGroup`/`AStat`
- **표시 · 선택 · 피드백:** `ATag`(+`.primary`) · `AEmojiTile`(+`.icon`) · `AOptionTile`(+`.numbered`, `AOptionState`) · `APickCard` · `AEmptyState`(+`.inline`) · `ASkeleton`(+`.circle`)
- **내비게이션 · 레이아웃:** `AFloatingNavigationBar`(표준 `NavigationDestination`) · `AAdaptiveNavigation`(넓은 창에서 `NavigationRail`) · `ATitleTabs` · `ABreadcrumb` ·
  `AWindowSize`(+`context.windowSize`) · `AContentWidth`
- **오버레이 · 바 · 스크롤:** `showABottomSheet`/`ABottomSheetScaffold` · `showAActionSheet`/`AActionSheetItem` (루트 내비게이터가 기본) · `ADialog` · `showAConfirmDialog` ·
  `ABottomCta` · `ASelectionBar`/`ASelectionBarAction` · `APaginatedListView` · `ALoadMoreIndicator`
- 위젯 테스트 80건 · 갤러리 앱에 컴포넌트 섹션.
- 옛 위젯은 아직 `legacy.dart` 에 있다(2.0.0 에서 삭제).

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
