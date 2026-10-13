# 옛 위젯에서 옮기기

1.0 이전 위젯은 1.x 의 `package:flutter_artis_ui_kit/legacy.dart` 에 있었고 **2.0.0 에서 삭제했다.**
남은 사용처는 import 경로로 찾는다.

```bash
grep -rln "flutter_artis_ui_kit/legacy.dart" lib/
```

## 대응표

1.0.0 에서 모두 쓸 수 있다. 표준 위젯으로 대체되는 것은 킷 테마가 모양을 맞춘다.

| 옛 위젯 | 옮길 곳 | 상태 |
|---|---|---|
| `AButton()` · `.large` · `.small` | `AButton` · `AButton.tonal` · `AButton.neutral` · `AButton.danger` · `AButton.text` (크기는 `size:`) | 1.0.0 |
| `ACard` · `ACardButton` | `ACard` | 1.0.0 |
| `AWell` | 표준 `InkWell` (테마의 `splashFactory` 가 물결을 끈다) | 1.0.0 |
| `ATextFormField` | 표준 `TextField` / `TextFormField` (테마의 `inputDecorationTheme`) | 1.0.0 |
| `APopupMenuButton` · `APopupMenuItem` | 표준 `PopupMenuButton` · `PopupMenuItem` (테마의 `popupMenuTheme`) | 1.0.0 |
| `ABottomNavigationBar` | `AFloatingNavigationBar` (항목은 표준 `NavigationDestination`) | 1.0.0 |
| `ASampleText` | 없음 | — |
