# Artis UI Kit

Flutter Material 위에 얹는 **간결한 디자인 시스템**이다.
톤(브랜드 색) 하나를 넘기면 앱 전체 테마가 만들어지고, 표준 위젯은 그 테마로 모양이 맞춰진다.
표준에 없는 부품만 `A` 접두사 위젯으로 제공한다.

> **상태: 0.2.0 — 토큰 · 테마 빌더.** 컴포넌트는 1.0.0 에서 나온다.
> 1.0 이전 위젯은 `legacy.dart` 로 옮겨 두었다(아래 "옛 위젯").

## 원칙

1. **Material 먼저.** 표준 위젯이 있으면 다시 만들지 않는다. 킷의 테마 빌더가 표준 위젯을 같은 모양으로 맞춘다.
2. **API 는 Material 처럼 작게.** `onPressed` · `child` · `selected` · `style` 같은 표준 이름, 콜백이 `null` 이면 비활성.
   변형은 named constructor(`AButton.tonal`), 실제로 필요한 파라미터만.
3. **테마는 한 곳.** 토큰과 컴포넌트 값은 `ThemeExtension<AThemeData>` 하나. 해석 순서는 위젯 파라미터 → `AThemeData` → `ColorScheme`/`TextTheme`.
4. **하드코딩 없음.** 색 · 모서리 · 간격은 토큰에서만 읽는다.
5. **접근성 기본값.** 터치 영역 48 이상, `Semantics`, 보이는 포커스, 글자 확대, RTL.
6. **의존성 0.** Flutter SDK 만 쓴다.

## 구조

```
lib/
├── flutter_artis_ui_kit.dart   공개 API (export 'src/…')
├── legacy.dart                 1.0 이전 위젯 — 2.0.0 에서 삭제
└── src/
    ├── foundation/   토큰 — 톤 · 팔레트 · 모서리/간격/모션 · 글자 · 대비 계산
    ├── theme/        AThemeData · AThemeBuilder (톤 → ThemeData)
    ├── layout/       창 너비(compact · medium · expanded) · 콘텐츠 폭
    ├── navigation/   알약 하단 탭 · 적응형 네비 · 제목 탭 · 브레드크럼
    ├── buttons/ · surfaces/ · lists/ · selection/ · display/ · feedback/ · overlays/ · bars/
    └── legacy/       옛 위젯 구현
example/              갤러리 앱 — 모든 컴포넌트를 상태 · 톤 · 다크 · 창 너비별로
test/                 위젯 테스트 · 접근성 테스트
doc/                  테마 · 컴포넌트 · 옛 위젯 이전 안내
```

컴포넌트 하나는 파일 하나다. `part` 파일을 쓰지 않는다(옛 위젯 제외).

## 설치

git 태그로 의존한다.

```yaml
dependencies:
  flutter_artis_ui_kit:
    git:
      url: https://github.com/jeongwoo0427/flutter_artis_ui_kit.git
      ref: v0.1.0
```

킷을 함께 고치며 개발할 때는 앱 루트에 `pubspec_overrides.yaml`(커밋하지 않는다)을 두어 로컬 경로로 덮는다.

```yaml
dependency_overrides:
  flutter_artis_ui_kit:
    path: ../flutter_artis_ui_kit
```

## 테마

```dart
final tone = ATone.fromBrand(const Color(0xFF3182F6)); // 또는 ATone(...) 으로 직접

MaterialApp(
  theme: AThemeBuilder.light(tone: tone, fontFamily: 'YourFont'),
  darkTheme: AThemeBuilder.dark(tone: tone, fontFamily: 'YourFont'),
);
```

- 톤이 바꾸는 것은 강조색 계열뿐이다. 회색(`ANeutrals`)과 의미색(`ASemanticColors`)은 고정이고 필요하면 빌더 파라미터로 바꾼다.
- 킷 토큰은 `AThemeData.of(context)` — `page` · `card` · `sunken` · `brand` · `semantic` · `radii` · `spacing` · `motion`.
- 표준 위젯(`FilledButton` · `TextField` · `SearchBar` · `showModalBottomSheet` · `SnackBar` …)은 따로 스타일을 주지 않아도 킷 모양이 된다.
- 앱 전용 색은 앱이 `ThemeExtension` 을 하나 더 만들어 `theme.copyWith(extensions: [...])` 로 붙인다.

## 옛 위젯

`AButton`(옛 API) · `ACard` · `ACardButton` · `AWell` · `ATextFormField` · `APopupMenuButton` · `ABottomNavigationBar` · `ASampleText` 는
`package:flutter_artis_ui_kit/legacy.dart` 에 있다. 새 코드에서 쓰지 않는다. 옮기는 방법은 [`doc/migration_from_legacy.md`](doc/migration_from_legacy.md).

## 개발

```bash
fvm flutter pub get
fvm flutter analyze
fvm flutter test
```

Flutter 버전은 `.fvmrc` 에 고정돼 있다. 버전은 SemVer, 변경은 [`CHANGELOG.md`](CHANGELOG.md).

## 라이선스

MIT — [`LICENSE`](LICENSE).
