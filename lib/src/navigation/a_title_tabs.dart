import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _fontSize = 24;
const double _dividerWidth = 1.5;
const double _dividerHeight = 18;
const double _minTapHeight = 48;

/// 앱바 제목 자리에 두는 탭 — `문제은행 | 문제집` 처럼 제목 여러 개를 구분선으로 나누고
/// 선택한 것만 진하게 보인다.
///
/// 다른 제목을 누르면 [onSelected] 가 불리고, 이미 선택된 제목을 누르면 아무 일도 없다.
/// 긴 언어에서 자리가 모자라면 넘치지 않고 줄여서 맞춘다.
///
/// ```dart
/// AppBar(title: ATitleTabs(labels: const ['문제은행', '문제집'], selectedIndex: i, onSelected: onTab))
/// ```
class ATitleTabs extends StatelessWidget {
  /// [labels] 중 [selectedIndex] 번째를 선택 상태로 그린다.
  const ATitleTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    this.onSelected,
  }) : assert(0 <= selectedIndex && selectedIndex < labels.length);

  /// 제목들.
  final List<String> labels;

  /// 선택된 제목의 index.
  final int selectedIndex;

  /// 선택되지 않은 제목을 눌렀을 때. `null` 이면 누를 수 없다.
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final a = AThemeData.of(context);
    final base = theme.textTheme.headlineLarge?.copyWith(fontSize: _fontSize);

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0)
              Container(
                width: _dividerWidth,
                height: _dividerHeight,
                margin: EdgeInsets.symmetric(horizontal: a.spacing.md),
                color: cs.outlineVariant,
              ),
            Semantics(
              button: true,
              selected: i == selectedIndex,
              child: InkWell(
                onTap: i == selectedIndex || onSelected == null
                    ? null
                    : () => onSelected!(i),
                borderRadius: BorderRadius.circular(a.radii.sm),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: _minTapHeight),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      labels[i],
                      style: base?.copyWith(
                        color: i == selectedIndex ? cs.onSurface : cs.outline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
