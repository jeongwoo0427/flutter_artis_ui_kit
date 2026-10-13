import 'package:flutter/widgets.dart';

/// 창 너비 구간 — Material 3 window size class 기준(600 · 840).
///
/// ```dart
/// if (context.windowSize == AWindowSize.expanded) { /* 레일 · 두 칸 */ }
/// ```
enum AWindowSize {
  /// 600 미만 — 휴대폰 세로.
  compact,

  /// 600 이상 840 미만 — 폴더블 · 작은 태블릿.
  medium,

  /// 840 이상 — 태블릿 가로 · 데스크톱.
  expanded;

  /// [context] 의 화면 너비로 구간을 정한다.
  static AWindowSize of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  /// 논리 픽셀 너비 [width] 의 구간.
  static AWindowSize fromWidth(double width) {
    if (width < 600) return compact;
    if (width < 840) return medium;
    return expanded;
  }
}

/// `context.windowSize` 로 [AWindowSize.of] 를 짧게 쓴다.
extension AWindowSizeContext on BuildContext {
  /// 지금 창의 너비 구간.
  AWindowSize get windowSize => AWindowSize.of(this);
}
