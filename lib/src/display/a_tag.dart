import 'package:flutter/material.dart';

import '../foundation/contrast.dart';
import '../theme/a_theme_data.dart';

/// [ATag] 크기 — 높이 20 / 24 / 30(글자 확대 시 늘어난다).
enum ATagSize {
  /// 높이 20, 글자 11.
  xsmall,

  /// 높이 24, 글자 12.5.
  small,

  /// 높이 30, 글자 14.
  medium,
}

/// 상호작용 없는 작은 라벨(알약 태그).
///
/// [color] 를 주면 그 색의 연한 면 위에 대비 4.5 이상으로 맞춘 글자를 올린다. 없으면 회색.
///
/// ```dart
/// ATag('정답', color: AThemeData.of(context).semantic.positive)
/// ```
class ATag extends StatelessWidget {
  /// 회색 또는 [color] 계열 태그.
  const ATag(
    this.label, {
    super.key,
    this.color,
    this.icon,
    this.size = ATagSize.small,
  }) : _primary = false;

  /// `primaryContainer` 면 · `onPrimaryContainer` 글자 태그.
  const ATag.primary(
    this.label, {
    super.key,
    this.icon,
    this.size = ATagSize.small,
  }) : color = null,
       _primary = true;

  /// 글자.
  final String label;

  /// 강조색. 면은 이 색 12%, 글자는 대비를 맞춘 같은 계열 색.
  final Color? color;

  /// 글자 앞 아이콘(보통 `Icon`). 색 · 크기는 태그가 정한다.
  final Widget? icon;

  /// 크기.
  final ATagSize size;

  final bool _primary;

  // 높이는 고정하지 않고 (목표 높이 - 줄높이) / 2 를 세로 여백으로 쓴다.
  static const _metrics = {
    ATagSize.xsmall: (padding: 6.0, font: 11.0, height: 20.0),
    ATagSize.small: (padding: 8.0, font: 12.5, height: 24.0),
    ATagSize.medium: (padding: 10.0, font: 14.0, height: 30.0),
  };
  static const _lineHeight = 1.2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = AThemeData.of(context);
    final m = _metrics[size]!;
    final (bg, fg) = _colors(theme, a);

    final vertical = (m.height - m.font * _lineHeight) / 2;
    final style = theme.textTheme.labelMedium!.copyWith(
      fontSize: m.font,
      height: _lineHeight,
      color: fg,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(
          size == ATagSize.xsmall ? a.radii.xs : a.radii.sm,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: m.padding,
          vertical: vertical,
        ),
        // Row 대신 Text.rich — 폭이 무한한 부모(Row)에서도 깨지지 않고, 좁으면 말줄임한다.
        child: Text.rich(
          TextSpan(
            children: [
              if (icon != null)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: a.spacing.xs),
                    child: IconTheme.merge(
                      data: IconThemeData(color: fg, size: m.font + 2),
                      child: icon!,
                    ),
                  ),
                ),
              TextSpan(text: label),
            ],
          ),
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  (Color, Color) _colors(ThemeData theme, AThemeData a) {
    final cs = theme.colorScheme;
    if (_primary) return (cs.primaryContainer, cs.onPrimaryContainer);
    final c = color;
    if (c == null) return (cs.surfaceContainer, cs.onSurfaceVariant);

    final dark = theme.brightness == Brightness.dark;
    final bg = Color.alphaBlend(
      c.withValues(alpha: dark ? 0.18 : 0.12),
      a.card,
    );
    if (!dark) return (bg, darkenToContrast(c, bg, 4.5));
    // 다크 면에서는 어둡게 하면 대비가 떨어지므로 글자색 쪽으로 밝힌다.
    var fg = c;
    for (var t = 0.1; contrastRatio(fg, bg) < 4.5 && t <= 1; t += 0.1) {
      fg = Color.lerp(c, cs.onSurface, t)!;
    }
    return (bg, fg);
  }
}
