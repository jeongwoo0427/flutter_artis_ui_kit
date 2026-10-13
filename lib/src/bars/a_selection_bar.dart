import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _maxContentWidth = 640;
const Size _actionMinSize = Size(62, 52);
const double _actionIconSize = 22;
const double _actionIconGap = 2;

/// [ASelectionBar] 의 아이콘 + 이름 버튼 하나.
@immutable
class ASelectionBarAction {
  /// 버튼을 만든다. [onPressed] 가 `null` 이면 비활성.
  const ASelectionBarAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });

  /// 아이콘.
  final Widget icon;

  /// 아이콘 아래 이름.
  final String label;

  /// 눌렀을 때. `null` 이면 비활성.
  final VoidCallback? onPressed;

  /// 삭제처럼 되돌리기 어려운 동작 — `colorScheme.error` 색.
  final bool destructive;
}

/// 여러 개를 고른 상태에서 화면 아래에 뜨는 동작 바.
///
/// 작은 아이콘 버튼들([actions]) 뒤에 남은 폭을 [primary] 가 채운다. [note] 는 그 위 오른쪽 한 줄.
/// 콘텐츠는 최대 640 폭으로 가운데에 놓인다.
///
/// ```dart
/// ASelectionBar(
///   note: const Text('폴더 1개는 빼고 풀어요'),
///   actions: [
///     ASelectionBarAction(icon: const Icon(Icons.drive_file_move), label: '이동', onPressed: move),
///     ASelectionBarAction(icon: const Icon(Icons.delete), label: '삭제', onPressed: delete, destructive: true),
///   ],
///   primary: FilledButton(onPressed: play, child: const Text('2문제 풀어보기')),
/// )
/// ```
class ASelectionBar extends StatelessWidget {
  /// 동작 바를 만든다.
  const ASelectionBar({
    super.key,
    required this.actions,
    required this.primary,
    this.note,
  });

  /// 앞쪽 아이콘 + 이름 버튼들.
  final List<ASelectionBarAction> actions;

  /// 남은 폭을 채우는 주 버튼.
  final Widget primary;

  /// 버튼 줄 위 오른쪽의 짧은 안내(`bodySmall`, 3차 글자색).
  final Widget? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = AThemeData.of(context);

    return Material(
      color: a.card,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: SafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: a.spacing.md),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: a.spacing.lg,
              end: a.spacing.lg,
              top: a.spacing.sm,
            ),
            child: Align(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (note != null)
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: a.spacing.xs,
                          bottom: a.spacing.xs,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: DefaultTextStyle.merge(
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: a.textTertiary,
                            ),
                            textAlign: TextAlign.end,
                            child: note!,
                          ),
                        ),
                      ),
                    Row(
                      spacing: a.spacing.xs,
                      children: [
                        for (final action in actions) _ActionButton(action),
                        Expanded(child: primary),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton(this.action);

  final ASelectionBarAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = AThemeData.of(context);
    final cs = theme.colorScheme;
    final enabled = action.onPressed != null;
    final color = !enabled
        ? cs.outline
        : action.destructive
        ? cs.error
        : cs.onSurfaceVariant;

    return Semantics(
      button: true,
      enabled: enabled,
      child: InkWell(
        onTap: action.onPressed,
        borderRadius: BorderRadius.circular(a.radii.md),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: _actionMinSize.width,
            minHeight: _actionMinSize.height,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: a.spacing.xs),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconTheme.merge(
                  data: IconThemeData(color: color, size: _actionIconSize),
                  child: action.icon,
                ),
                const SizedBox(height: _actionIconGap),
                Text(
                  action.label,
                  style: theme.textTheme.labelMedium?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
