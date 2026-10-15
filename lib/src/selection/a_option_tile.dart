import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

/// [AOptionTile] 상태.
enum AOptionState {
  /// 고르지 않음.
  idle,

  /// 고름(응시 중).
  selected,

  /// 정답(채점 후).
  positive,

  /// 오답(채점 후).
  negative,
}

/// 객관식 선택지처럼 한 줄짜리 고를 수 있는 타일.
///
/// `selected` · `positive` · `negative` 는 모두 스크린리더에 "선택됨" 으로 읽힌다.
/// [onTap] 이 `null` 이면 비활성(채점 결과 표시 등).
///
/// ```dart
/// AOptionTile.numbered(
///   number: 1,
///   label: const Text('서울'),
///   state: picked == 0 ? AOptionState.selected : AOptionState.idle,
///   onTap: () => setState(() => picked = 0),
/// )
/// ```
class AOptionTile extends StatelessWidget {
  /// 자유 [leading] 을 받는 선택지.
  const AOptionTile({
    super.key,
    required this.label,
    this.leading,
    this.trailing,
    this.state = AOptionState.idle,
    this.onTap,
  }) : number = null;

  /// 앞에 28×28 번호 배지를 두는 선택지.
  const AOptionTile.numbered({
    super.key,
    required int this.number,
    required this.label,
    this.trailing,
    this.state = AOptionState.idle,
    this.onTap,
  }) : leading = null;

  /// 선택지 내용(보통 `Text`).
  final Widget label;

  /// 앞 위젯.
  final Widget? leading;

  /// 뒤 위젯. `selected` 인데 비어 있으면 체크 아이콘을 둔다.
  final Widget? trailing;

  /// 번호 배지 숫자([AOptionTile.numbered]).
  final int? number;

  /// 상태.
  final AOptionState state;

  /// 눌렀을 때. `null` 이면 비활성.
  final VoidCallback? onTap;

  static const _minHeight = 60.0;
  static const _paddingHorizontal = 18.0;
  static const _gap = 14.0;
  static const _borderWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final a = AThemeData.of(context);
    // (면, 글자, 테두리 · 배지)
    final (bg, fg, accent) = switch (state) {
      AOptionState.idle => (a.sunken, cs.onSurface, null),
      AOptionState.selected => (
        cs.primaryContainer,
        cs.onPrimaryContainer,
        a.brand,
      ),
      AOptionState.positive => (
        a.semantic.positiveContainer,
        a.semantic.onPositiveContainer,
        a.semantic.positive,
      ),
      AOptionState.negative => (
        a.semantic.negativeContainer,
        a.semantic.onNegativeContainer,
        a.semantic.negative,
      ),
    };
    final radius = BorderRadius.circular(a.radii.lg);

    final lead = number != null
        ? _NumberBadge(number: number!, state: state)
        : leading;
    final trail =
        trailing ??
        (state == AOptionState.selected
            ? Icon(Icons.check_rounded, size: 22, color: cs.primary)
            : null);

    return Semantics(
      container: true,
      button: true,
      selected: state != AOptionState.idle,
      enabled: onTap != null,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: accent == null
              ? BorderSide.none
              : BorderSide(color: accent, width: _borderWidth),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _minHeight),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: _paddingHorizontal,
                vertical: a.spacing.md,
              ),
              child: Row(
                spacing: _gap,
                children: [
                  ?lead,
                  Expanded(
                    child: DefaultTextStyle.merge(
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                      child: label,
                    ),
                  ),
                  ?trail,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number, required this.state});

  final int number;
  final AOptionState state;

  static const _extent = 28.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = AThemeData.of(context);
    final fill = switch (state) {
      AOptionState.idle => null,
      AOptionState.selected => a.primaryFill,
      AOptionState.positive => a.semantic.positive,
      AOptionState.negative => a.semantic.negative,
    };
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: _extent, minHeight: _extent),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill ?? a.card,
          borderRadius: BorderRadius.circular(a.radii.sm),
        ),
        child: Center(
          widthFactor: 1,
          heightFactor: 1,
          child: Text(
            '$number',
            style: theme.textTheme.labelLarge!.copyWith(
              fontSize: 14,
              color: fill == null
                  ? a.textTertiary
                  : state == AOptionState.selected
                  ? a.onPrimaryFill
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
