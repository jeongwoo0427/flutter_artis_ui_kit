import 'package:flutter/material.dart';

import '../foundation/a_palette.dart';
import '../foundation/a_tokens.dart';

/// 킷 위젯이 `ColorScheme` · `TextTheme` 말고 읽는 값 — 면 · 브랜드 · 의미색 · 모서리 · 간격 · 움직임 · 유리.
///
/// [AThemeBuilder] 가 채운다. 직접 만든 `ThemeData` 에 이 확장이 없으면 [of] 가 `ColorScheme` 에서 기본값을 만든다.
/// 서브트리만 바꾸려면 `Theme(data: Theme.of(context).copyWith(extensions: [...]))` 를 쓴다.
@immutable
class AThemeData extends ThemeExtension<AThemeData> {
  /// 모든 값을 지정한다.
  const AThemeData({
    required this.page,
    required this.card,
    required this.sunken,
    required this.brand,
    required this.textTertiary,
    required this.semantic,
    this.radii = const ARadii(),
    this.spacing = const ASpacing(),
    this.motion = const AMotion(),
    this.glass = const AGlass(),
  });

  /// `ColorScheme` 만 있는 테마에서 쓰는 기본값.
  factory AThemeData.fallback(ThemeData theme) {
    final cs = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    return AThemeData(
      page: theme.scaffoldBackgroundColor,
      card: cs.surface,
      sunken: cs.surfaceContainer,
      brand: cs.primary,
      textTertiary: cs.outline,
      semantic: dark ? ASemanticColors.dark : ASemanticColors.light,
    );
  }

  /// 가장 가까운 테마의 값. 없으면 [AThemeData.fallback].
  static AThemeData of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<AThemeData>() ?? AThemeData.fallback(theme);
  }

  /// 페이지 배경.
  final Color page;

  /// 카드 면.
  final Color card;

  /// 카드 안에서 한 단계 들어간 면(선택지 · 입력창).
  final Color sunken;

  /// 글자가 올라가지 않는 강조 면(진행도 · 선택 테두리).
  final Color brand;

  /// 보조 정보 글자.
  final Color textTertiary;

  /// 의미색.
  final ASemanticColors semantic;

  /// 모서리 반경.
  final ARadii radii;

  /// 간격.
  final ASpacing spacing;

  /// 움직임.
  final AMotion motion;

  /// 떠 있는 바(하단 탭 · 상단 바)의 유리 면.
  final AGlass glass;

  @override
  AThemeData copyWith({
    Color? page,
    Color? card,
    Color? sunken,
    Color? brand,
    Color? textTertiary,
    ASemanticColors? semantic,
    ARadii? radii,
    ASpacing? spacing,
    AMotion? motion,
    AGlass? glass,
  }) {
    return AThemeData(
      page: page ?? this.page,
      card: card ?? this.card,
      sunken: sunken ?? this.sunken,
      brand: brand ?? this.brand,
      textTertiary: textTertiary ?? this.textTertiary,
      semantic: semantic ?? this.semantic,
      radii: radii ?? this.radii,
      spacing: spacing ?? this.spacing,
      motion: motion ?? this.motion,
      glass: glass ?? this.glass,
    );
  }

  @override
  AThemeData lerp(AThemeData? other, double t) {
    if (other == null) return this;
    // 치수 토큰은 보간하지 않는다 — 테마가 바뀌는 순간 같이 바뀐다.
    return AThemeData(
      page: Color.lerp(page, other.page, t)!,
      card: Color.lerp(card, other.card, t)!,
      sunken: Color.lerp(sunken, other.sunken, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      semantic: ASemanticColors.lerp(semantic, other.semantic, t),
      radii: t < 0.5 ? radii : other.radii,
      spacing: t < 0.5 ? spacing : other.spacing,
      motion: t < 0.5 ? motion : other.motion,
      glass: t < 0.5 ? glass : other.glass,
    );
  }
}
