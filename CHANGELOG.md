# Changelog

## 6.0.0

- **깨지는 변경:** `AAdaptiveNavigation` → **`AFloatingNavigationScaffold`**. 넓은 창(≥ 840)에서 `NavigationRail` 로 바꾸던 분기를 없앴다 — 폰 · 태블릿 모두 같은 떠 있는 알약 하단 탭.
  인자(`destinations` · `selectedIndex` · `onDestinationSelected` · `body` · `navigationVisible`)와 유리 흐림 그룹(`BackdropGroup`)은 그대로다. 레일이 필요하면 표준 `NavigationRail` 을 직접 쓴다(킷 테마가 모양을 맞춘다).

## 5.0.0

- **깨지는 변경:** `AGlass.opacity` → **`appBarOpacity`**(기본 0.70) · **`navigationBarOpacity`**(기본 0.56). 흐림 · 테두리는 두 바가 같고 불투명도만 바마다 — 상단 바는 조금 더 불투명하게, 하단 탭은 더 비치게(4.x 는 둘 다 0.64).

## 4.2.0

- `AGlass` 에 테두리 — `borderColor`(기본: 글자색 8%) · `borderWidth`(기본 1, `0` 이면 없음). 하단 탭과 상단 바가 같은 값을 쓴다.
- `AFloatingNavigationBar`: 알약 외곽선을 `AGlass` 테두리로(모양은 그대로).
- `AAppBar`: 아래 테두리를 **스크롤했을 때만** — Material `AppBar` 의 scrolled-under 와 같은 방식(Scaffold 의 `ScrollNotificationObserver`, 깊이 0 세로 스크롤)으로 본문이 바 밑으로 들어가면 `motion.medium` 동안 나타나고, 맨 위로 오면 사라진다.

## 4.1.0

- 유리 면 성능: 흐림을 `BackdropFilter.grouped` 로 — `AAdaptiveNavigation`(좁은 창)이 `BackdropGroup` 을 깔아, 탭 화면의 `AAppBar` 와 하단 탭이 뒤 내용을 **한 번만** 흐려 나눠 쓴다(Impeller). 두 바는 겹치지 않고 같은 `AGlass` 를 쓴다.
- `AAppBar`: 본문이 바 뒤로 오지 않는 Scaffold(`extendBodyBehindAppBar: false`)에서는 흐리지 않고 불투명하게 — 보이는 것은 같고 흐림 비용이 없다.

## 4.0.0

- **`AAppBar`** — 유리처럼 그리는 상단 바. Material `AppBar` 자리에 같은 이름의 인자(`title` · `leading` · `actions` · `bottom` · `centerTitle` · `titleSpacing` · `leadingWidth` · `backgroundColor` · `foregroundColor`)로 쓴다.
  `Scaffold(extendBodyBehindAppBar: true)` 면 바 뒤로 지나가는 내용이 흐려져 비친다. 바가 투명이라 상태 표시줄 글자색은 면 색 기준으로 정한다.
- **`AGlass`** 토큰(`opacity` · `blurSigma`, 끄기 `AGlass.none`) — `AThemeData.glass` · `AThemeBuilder.light/dark(glass:)`. 하단 탭과 상단 바가 **같은 값**을 읽는다.
  기본값은 3.3.0 보다 뒤가 더 비치게: 불투명도 72% → **64%**, 흐림 18 → **12**.
- **깨지는 변경:** `AFloatingNavigationBar.blurSigma` → `glass`(`AGlass?`, 기본 테마 값). `backgroundColor` 는 이제 불투명도가 곱해지는 바탕색. `AAdaptiveNavigation` 의 `navigationBackgroundColor` · `navigationBlurSigma`(3.3.0) 삭제 — 테마로 정한다.

## 3.3.0

- `AFloatingNavigationBar`: 알약을 **유리처럼** — 반투명 면 뒤로 지나가는 내용을 흐린다(`BackdropFilter`). 흰 카드 · 글자 위에서도 탭이 떠 보이고 뒤 글자와 섞이지 않는다.
  면 색 `backgroundColor`(기본: 카드색, 다크는 `surfaceContainer` 의 72%) · 흐림 `blurSigma`(기본 18, `0` 이면 끔)를 고를 수 있다. 옅은 외곽선(onSurface 8%)을 두르고, 그림자는 알약 **바깥에만** 그린다(반투명 면 아래로 비치지 않게).
  예전 면은 페이지색 불투명이었다 — 되돌리려면 `backgroundColor: page, blurSigma: 0`.
- `AAdaptiveNavigation`: `navigationBackgroundColor` · `navigationBlurSigma` 로 위 둘을 넘긴다.

## 3.2.0

- 밝은 테마의 연한 강조 면(`primaryContainer`)을 브랜드색 11% → **16%** 로 — 회색 페이지(`page`) 위에 올린 강조 카드가 페이지와 거의 같아 보이던 것. 톤과 무관하게 브랜드색에서 만들므로 어떤 톤이든 같은 만큼 진해진다.
  `ATone.ink` 도 새 면 기준으로 4.5:1 을 맞춘다. 어두운 테마는 그대로(22%).
  이 면을 쓰는 것: `AButton.tonal` · `AListRow(selected)` · `ABreadcrumb` 현재 칸 · `AOptionTile` · `ATag.primary` · `APickCard` 선택 · 세그먼트 버튼 선택 칸 · `NavigationRail` 표시.

## 3.1.1

- `ATitleTabs`: 글자를 앱바 제목 스타일(`appBarTheme.titleTextStyle`)로, 높이를 글자 한 줄로 — 같은 자리에 평범한 제목 `Text` 를 둘 때와 제목 크기 · 부제 위치가 같다(예전엔 24 + 최소 48 높이라 제목을 바꿔 끼우면 앱바가 달라 보였다).

## 3.1.0

- `AListRow`: 앞 위젯(`leading`)이 생기거나 바뀌면 폭이 `motion.medium` 동안 부드럽게 늘고 줄어 뒤 내용이 밀려난다(선택 모드의 체크가 순간이동하지 않게). `leading` 이 없으면 앞 간격도 없다.

## 3.0.0

- **깨지는 변경:** `ABottomCta` → **`ABottomBar`**. 하단 버튼 바 하나로 합쳤다 — 면 색(`backgroundColor`, 기본 `card`), 위 경계(`edge`: `line` 기본 · `fade` · `none`),
  `fadeHeight` · `padding` · `maxContentWidth` 를 고를 수 있다. 옛 `ABottomCta(fade: true)` = `ABottomBar(backgroundColor: scaffoldBackgroundColor, edge: ABottomBarEdge.fade)`.
- `ASelectionBar` 가 `ABottomBar` 위에서 그려진다 — `backgroundColor` · `edge` 를 그대로 받는다.

## 2.2.0

- `AMotion.long`(360ms) — 화면 가장자리 바가 들고 나는 것처럼 멀리 움직이는 전환용.
- `AAdaptiveNavigation`: 하단 탭 숨김 · 보임을 `motion.long` + `easeInOutCubic` 으로(200ms 는 화면 밖까지 가기엔 짧아 순간이동처럼 보였다).

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
