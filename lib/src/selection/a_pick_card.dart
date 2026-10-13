import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

/// 두 칸 그리드에서 하나를 고르는 작은 카드(아이콘 · 제목 · 설명).
///
/// ```dart
/// APickCard(
///   leading: const Text('📝'),
///   title: const Text('객관식'),
///   subtitle: const Text('보기 중 고르기'),
///   selected: type == QuizType.choice,
///   onTap: () => setState(() => type = QuizType.choice),
/// )
/// ```
class APickCard extends StatelessWidget {
  /// 고를 수 있는 카드.
  const APickCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.selected = false,
    this.onTap,
  });

  /// 제목.
  final Widget title;

  /// 제목 아래 한 줄 설명.
  final Widget? subtitle;

  /// 제목 위 아이콘 · 이모지.
  final Widget? leading;

  /// 골랐는지.
  final bool selected;

  /// 눌렀을 때. `null` 이면 비활성.
  final VoidCallback? onTap;

  static const _padding = 14.0;
  static const _borderWidth = 1.5;
  static const _leadingSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;
    final a = AThemeData.of(context);

    return Semantics(
      container: true,
      button: true,
      selected: selected,
      enabled: onTap != null,
      child: Material(
        color: selected ? cs.primaryContainer : a.sunken,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(a.radii.lg),
          side: selected
              ? BorderSide(color: a.brand, width: _borderWidth)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.all(_padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (leading != null) ...[
                  IconTheme.merge(
                    data: const IconThemeData(size: _leadingSize),
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(fontSize: _leadingSize, height: 1),
                      child: leading!,
                    ),
                  ),
                  SizedBox(height: a.spacing.sm),
                ],
                DefaultTextStyle.merge(
                  style: text.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected ? cs.onPrimaryContainer : cs.onSurface,
                  ),
                  child: title,
                ),
                if (subtitle != null)
                  DefaultTextStyle.merge(
                    style: text.bodySmall!.copyWith(color: cs.onSurfaceVariant),
                    child: subtitle!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
