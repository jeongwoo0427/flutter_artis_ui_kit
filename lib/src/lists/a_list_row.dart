import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;

import '../theme/a_theme_data.dart';

const double _minHeight = 56;
const double _verticalPadding = 9;

/// 행끼리 띄우는 위아래 틈 — 선택된 행이 이어져도 면이 한 덩어리로 붙지 않는다.
const double _gap = 2;

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

    // 잉크 · 선택 면이 콘텐츠보다 좌우로 [bleed] 만큼 넓게 번진다 — 콘텐츠 자리는 그대로.
    final bleed = a.spacing.md;
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minHeight - _gap * 2),
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

    final surface = Material(
      color: selected ? cs.primaryContainer : Colors.transparent,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: bleed),
          child: row,
        ),
      ),
    );

    return MergeSemantics(
      child: Semantics(
        selected: selected,
        button: onTap != null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: _gap),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 폭이 정해지지 않은 곳(가로 스크롤 등)에서는 번지지 않는다.
              if (!constraints.hasBoundedWidth) return surface;
              final width = constraints.maxWidth + bleed * 2;
              return OverflowBox(
                minWidth: width,
                maxWidth: width,
                fit: OverflowBoxFit.deferToChild,
                child: surface,
              );
            },
          ),
        ),
      ),
    );
  }
}
