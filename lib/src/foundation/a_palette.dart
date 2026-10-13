import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// 중립 회색 — 톤과 무관하게 고정. 테마 빌더가 `ColorScheme` 의 면 · 글자 역할에 펼친다.
@immutable
class ANeutrals {
  /// 모든 값을 지정한다.
  const ANeutrals({
    required this.page,
    required this.card,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.disabled,
    required this.divider,
    required this.fillLow,
    required this.fill,
    required this.fillHigh,
    required this.fillHighest,
    required this.inverse,
  });

  /// 차가운 중립 회색 — 라이트.
  static const light = ANeutrals(
    page: Color(0xFFF2F4F6),
    card: Color(0xFFFFFFFF),
    text: Color(0xFF191F28),
    textSecondary: Color(0xFF4E5968),
    textTertiary: Color(0xFF8B95A1),
    disabled: Color(0xFFB0B8C1),
    divider: Color(0xFFE5E8EB),
    fillLow: Color(0xFFF9FAFB),
    fill: Color(0xFFF2F4F6),
    fillHigh: Color(0xFFE5E8EB),
    fillHighest: Color(0xFFD1D6DB),
    inverse: Color(0xFF2B3038),
  );

  /// 차가운 중립 회색 — 다크.
  static const dark = ANeutrals(
    page: Color(0xFF101114),
    card: Color(0xFF1B1D22),
    text: Color(0xFFF2F4F6),
    textSecondary: Color(0xFFB5BCC5),
    textTertiary: Color(0xFF7F8894),
    disabled: Color(0xFF5F6773),
    divider: Color(0xFF33373E),
    fillLow: Color(0xFF212329),
    fill: Color(0xFF26292F),
    fillHigh: Color(0xFF33373E),
    fillHighest: Color(0xFF474D56),
    inverse: Color(0xFF3A3F47),
  );

  /// 페이지 배경.
  final Color page;

  /// 카드 · 시트 · 다이얼로그 면.
  final Color card;

  /// 제목 · 숫자.
  final Color text;

  /// 본문.
  final Color textSecondary;

  /// 보조 정보(13px 이상에만 — 대비가 낮다).
  final Color textTertiary;

  /// 비활성 글자 · 아이콘.
  final Color disabled;

  /// 구분선.
  final Color divider;

  /// 눌림 면.
  final Color fillLow;

  /// 선택지 · 입력창 면.
  final Color fill;

  /// [fill] 보다 한 단계 진한 면.
  final Color fillHigh;

  /// 가장 진한 채움 면.
  final Color fillHighest;

  /// 스낵바 · 툴팁 같은 반전 면.
  final Color inverse;
}

/// 의미색 — 정답/성공(positive) · 오답/위험(negative) · 경고(warning). 톤과 무관하게 고정.
@immutable
class ASemanticColors {
  /// 모든 값을 지정한다.
  const ASemanticColors({
    required this.positive,
    required this.positiveContainer,
    required this.onPositiveContainer,
    required this.negative,
    required this.negativeContainer,
    required this.onNegativeContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
  });

  /// 라이트.
  static const light = ASemanticColors(
    positive: Color(0xFF0EA472),
    positiveContainer: Color(0xFFE3F7EF),
    onPositiveContainer: Color(0xFF07875D),
    negative: Color(0xFFF04452),
    negativeContainer: Color(0xFFFFEEEF),
    onNegativeContainer: Color(0xFFD22F3D),
    warning: Color(0xFFF98A2B),
    warningContainer: Color(0xFFFFF1E6),
    onWarningContainer: Color(0xFFC85F0C),
  );

  /// 다크.
  static const dark = ASemanticColors(
    positive: Color(0xFF0EA472),
    positiveContainer: Color(0x2E0EA472),
    onPositiveContainer: Color(0xFF3DCB98),
    negative: Color(0xFFF04452),
    negativeContainer: Color(0x2EF04452),
    onNegativeContainer: Color(0xFFFF7C86),
    warning: Color(0xFFF98A2B),
    warningContainer: Color(0x2EF98A2B),
    onWarningContainer: Color(0xFFFFA45C),
  );

  /// 정답 · 성공.
  final Color positive;

  /// [positive] 의 연한 면.
  final Color positiveContainer;

  /// [positiveContainer] 위 글자.
  final Color onPositiveContainer;

  /// 오답 · 삭제 · 위험(= `ColorScheme.error`).
  final Color negative;

  /// [negative] 의 연한 면.
  final Color negativeContainer;

  /// [negativeContainer] 위 글자.
  final Color onNegativeContainer;

  /// 경고 · 진행 중.
  final Color warning;

  /// [warning] 의 연한 면.
  final Color warningContainer;

  /// [warningContainer] 위 글자.
  final Color onWarningContainer;

  /// 두 의미색 사이를 보간한다(테마 전환 애니메이션용).
  static ASemanticColors lerp(ASemanticColors a, ASemanticColors b, double t) {
    Color l(Color x, Color y) => Color.lerp(x, y, t)!;
    return ASemanticColors(
      positive: l(a.positive, b.positive),
      positiveContainer: l(a.positiveContainer, b.positiveContainer),
      onPositiveContainer: l(a.onPositiveContainer, b.onPositiveContainer),
      negative: l(a.negative, b.negative),
      negativeContainer: l(a.negativeContainer, b.negativeContainer),
      onNegativeContainer: l(a.onNegativeContainer, b.onNegativeContainer),
      warning: l(a.warning, b.warning),
      warningContainer: l(a.warningContainer, b.warningContainer),
      onWarningContainer: l(a.onWarningContainer, b.onWarningContainer),
    );
  }
}
