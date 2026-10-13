import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _verticalPadding = 7;

/// 라벨 · 값 한 줄 — 왼쪽 라벨(보조색), 오른쪽 정렬 값(굵게).
///
/// ```dart
/// AKeyValueRow(label: const Text('제한 시간'), value: const Text('10분'))
/// ```
class AKeyValueRow extends StatelessWidget {
  /// 키-값 행을 만든다.
  const AKeyValueRow({super.key, required this.label, required this.value});

  /// 왼쪽 라벨.
  final Widget label;

  /// 오른쪽 값.
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    final cs = Theme.of(context).colorScheme;
    final body = Theme.of(context).textTheme.bodyMedium;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: a.spacing.md,
          children: [
            DefaultTextStyle.merge(
              style: body?.copyWith(color: cs.onSurfaceVariant),
              child: label,
            ),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: DefaultTextStyle.merge(
                  style: body?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.end,
                  child: value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
