import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

/// [AStatGroup] 의 한 칸.
@immutable
class AStat {
  /// 통계 한 칸.
  const AStat({required this.label, required this.value, this.valueColor});

  /// 위쪽 작은 라벨.
  final String label;

  /// 큰 숫자 — 이미 포맷된 문자열(`'1,284'`).
  final String value;

  /// 숫자 색. 기본 onSurface.
  final Color? valueColor;
}

/// 통계 여러 칸 — 같은 폭으로 나누고 사이에 1px 세로 구분선.
///
/// ```dart
/// AStatGroup(stats: const [
///   AStat(label: '푼 문제 수', value: '1,284'),
///   AStat(label: '진행 퀴즈', value: '3'),
/// ])
/// ```
class AStatGroup extends StatelessWidget {
  /// 통계 묶음을 만든다.
  const AStatGroup({super.key, required this.stats});

  /// 칸들 — 왼쪽부터.
  final List<AStat> stats;

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final labelStyle = t.bodySmall?.copyWith(
      color: a.textTertiary,
      fontWeight: FontWeight.w600,
    );
    final valueStyle = t.headlineSmall?.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return IntrinsicHeight(
      child: Row(
        children: [
          for (final (i, stat) in stats.indexed) ...[
            if (i > 0)
              VerticalDivider(width: 1, thickness: 1, color: cs.outlineVariant),
            Expanded(
              child: MergeSemantics(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stat.label,
                      style: labelStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      stat.value,
                      style: valueStyle?.copyWith(color: stat.valueColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
