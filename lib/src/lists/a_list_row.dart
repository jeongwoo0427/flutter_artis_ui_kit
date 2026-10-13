import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _minHeight = 56;
const double _verticalPadding = 11;

/// 목록 한 줄 — 앞(이모지 타일 등) · 제목(2줄) · 부제 · 끝 값 · 화살표.
///
/// [selected] 면 primaryContainer 면을 깐다. 면은 행 바깥으로 `spacing.md` 만큼 번져서
/// 글자 줄은 다른 행과 맞고 강조만 넓게 보인다 — 부모에 그만큼의 여백(카드 안쪽 등)이 있어야 한다.
///
/// ```dart
/// AListRow(
///   leading: const AEmojiTile('📘'),
///   title: Text(folder.name),
///   subtitle: Text('문제 ${folder.count}개'),
///   showChevron: true,
///   onTap: open,
/// )
/// ```
class AListRow extends StatelessWidget {
  /// 목록 행을 만든다.
  const AListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.showChevron = false,
  });

  /// 제목 — 최대 2줄.
  final Widget title;

  /// 제목 아래 메타 정보.
  final Widget? subtitle;

  /// 앞 위젯.
  final Widget? leading;

  /// 끝 값이나 위젯.
  final Widget? trailing;

  /// 선택 표시.
  final bool selected;

  /// 탭했을 때.
  final VoidCallback? onTap;

  /// 길게 눌렀을 때.
  final VoidCallback? onLongPress;

  /// 끝에 `›` 화살표를 붙인다.
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(a.radii.md);
    final tertiary = TextStyle(color: a.textTertiary);

    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
        child: Row(
          spacing: a.spacing.md,
          children: [
            ?leading,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: a.spacing.xs,
                children: [
                  DefaultTextStyle.merge(
                    style: t.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    child: title,
                  ),
                  if (subtitle != null)
                    DefaultTextStyle.merge(
                      style: t.bodySmall?.merge(tertiary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: subtitle!,
                    ),
                ],
              ),
            ),
            if (trailing != null)
              DefaultTextStyle.merge(
                style: t.bodyMedium?.merge(tertiary),
                child: trailing!,
              ),
            if (showChevron) Icon(Icons.chevron_right, color: cs.outline),
          ],
        ),
      ),
    );

    return MergeSemantics(
      child: Semantics(
        selected: selected,
        button: onTap != null,
        child: CustomPaint(
          painter: selected
              ? _BleedPainter(cs.primaryContainer, radius, a.spacing.md)
              : null,
          // 잉크가 선택 면 위에 그려지도록 투명 Material 을 한 겹 둔다.
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              borderRadius: radius,
              child: row,
            ),
          ),
        ),
      ),
    );
  }
}

/// 행 좌우로 [bleed] 만큼 번지는 둥근 면.
class _BleedPainter extends CustomPainter {
  const _BleedPainter(this.color, this.radius, this.bleed);

  final Color color;
  final BorderRadius radius;
  final double bleed;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(-bleed, 0, size.width + bleed, size.height);
    canvas.drawRRect(radius.toRRect(rect), Paint()..color = color);
  }

  @override
  bool shouldRepaint(_BleedPainter old) =>
      old.color != color || old.radius != radius || old.bleed != bleed;
}
