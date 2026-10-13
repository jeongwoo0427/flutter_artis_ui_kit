# Changelog

## 0.1.0

새 디자인 시스템(1.0.0)을 만들기 위한 구조 정리. 위젯 동작은 바뀌지 않았다.

- **Breaking:** 옛 위젯을 `package:flutter_artis_ui_kit/legacy.dart` 로 옮겼다.
  `package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart` 는 새 디자인 시스템의 공개 API 자리이며 아직 비어 있다.
- 패키지 구조 `lib/src/…`, 린트(`flutter_lints` + `public_member_api_docs`), CI, 갤러리 예제 앱 뼈대, MIT 라이선스.
- 의존 방식: git 태그 + 로컬 개발용 `pubspec_overrides.yaml`.

## 0.0.1

- 최초 위젯: `AButton` · `ACard` · `ACardButton` · `AWell` · `ATextFormField` · `APopupMenuButton` · `ABottomNavigationBar` · `ASampleText`.
