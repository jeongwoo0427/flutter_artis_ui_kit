import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

/// [ASegmentedControl] 의 한 칸.
@immutable
class ASegment<T> {
  /// 칸을 만든다.
  const ASegment({
    required this.value,
    required this.label,
    this.subtitle,
    this.enabled = true,
  });

  /// 이 칸을 고르면 넘기는 값.
  final T value;

  /// 칸 글자.
  final Widget label;

  /// 글자 아래 작은 설명 — 칸이 조금 높아진다.
  final Widget? subtitle;

  /// `false` 면 흐리게 그리고 고를 수 없다(누르면 [ASegmentedControl.onDisabledTap]).
  final bool enabled;
}

/// 둘 이상 중 하나를 고르는 세그먼트 — 회색 홈 위로 고른 칸의 흰 조각이 미끄러진다.
///
/// 칸을 누르면 조각이 그 칸으로 옮겨 가고, 조각을 잡고 끌면 손가락을 따라오다가 놓은 칸에 붙는다.
/// 칸 폭은 모두 같다 — 폭이 정해진 곳이면 그 폭을 나누고, 폭이 열린 곳(`Row` 안 등)이면 가장 긴 칸에 맞춘다.
/// 애니메이션 줄이기 설정(`MediaQuery.disableAnimationsOf`)이 켜져 있으면 바로 옮긴다.
///
/// ```dart
/// ASegmentedControl<Kind>(
///   segments: const [
///     ASegment(value: Kind.paper, label: Text('시험지')),
///     ASegment(value: Kind.summary, label: Text('요약 한 장')),
///   ],
///   selected: kind,
///   onChanged: (kind) => setState(() => this.kind = kind),
/// )
/// ```
class ASegmentedControl<T> extends StatefulWidget {
  /// 세그먼트를 만든다.
  const ASegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.onDisabledTap,
    this.trackColor,
  }) : assert(segments.length >= 2);

  /// 칸들 — 두 개 이상.
  final List<ASegment<T>> segments;

  /// 지금 고른 값.
  final T selected;

  /// 다른 칸을 골랐을 때. `null` 이면 전체가 비활성.
  final ValueChanged<T>? onChanged;

  /// 비활성 칸([ASegment.enabled] = false)을 눌렀을 때 — 왜 못 고르는지 안내할 때 쓴다.
  final ValueChanged<T>? onDisabledTap;

  /// 홈 색 — 기본은 `sunken`. 회색 면(`sunken`) 위에 둘 때는 홈이 묻히지 않게
  /// 한 단계 진한 `ColorScheme.surfaceContainerHigh` 를 넘긴다.
  final Color? trackColor;

  @override
  State<ASegmentedControl<T>> createState() => _ASegmentedControlState<T>();
}

class _ASegmentedControlState<T> extends State<ASegmentedControl<T>>
    with SingleTickerProviderStateMixin {
  static const _trackPadding = 3.0;
  static const _gap = 3.0;
  static const _minHeight = 40.0;

  /// 조각 위치 — 칸 번호 단위(0 = 첫 칸). 끄는 동안은 칸 사이 값도 가진다.
  late final AnimationController _thumb = AnimationController.unbounded(
    vsync: this,
    value: _selectedIndex.toDouble(),
  );

  /// 조각을 잡고 끄는 중인가 — 잡은 곳과 조각 왼쪽의 거리(칸 단위).
  double? _grab;

  int get _selectedIndex {
    final i = widget.segments.indexWhere((s) => s.value == widget.selected);
    return i < 0 ? 0 : i;
  }

  bool get _active => widget.onChanged != null;

  @override
  void didUpdateWidget(covariant ASegmentedControl<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_grab == null) _moveTo(_selectedIndex);
  }

  @override
  void dispose() {
    _thumb.dispose();
    super.dispose();
  }

  void _moveTo(int index) {
    if (_thumb.value == index) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _thumb.value = index.toDouble();
      return;
    }
    _thumb.animateTo(
      index.toDouble(),
      duration: AThemeData.of(context).motion.medium,
      curve: Curves.easeOutCubic,
    );
  }

  /// 고르기 — 바뀌면 알리고, 다음 프레임에 조각을 고른 값 자리로 맞춘다(부모가 값을 안 바꿨으면 제자리로 돌아온다).
  void _pick(int index) {
    final segment = widget.segments[index];
    if (!segment.enabled) {
      widget.onDisabledTap?.call(segment.value);
    } else if (index != _selectedIndex) {
      widget.onChanged?.call(segment.value);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _grab == null) _moveTo(_selectedIndex);
    });
  }

  /// 칸 하나의 폭과 첫 칸 왼쪽 — 손가락 위치를 칸 번호로 바꿀 때 쓴다.
  (double, double) _metrics() {
    final width = (context.size?.width ?? 0) - _trackPadding * 2;
    final n = widget.segments.length;
    return ((width - _gap * (n - 1)) / n, _trackPadding);
  }

  /// 손가락 x → 칸 번호 단위 위치(칸 왼쪽 기준).
  double _toUnits(double dx) {
    final (segment, start) = _metrics();
    return segment <= 0 ? 0 : (dx - start) / (segment + _gap);
  }

  void _onTapUp(TapUpDetails details) {
    final index = _toUnits(
      details.localPosition.dx,
    ).floor().clamp(0, widget.segments.length - 1);
    _pick(index);
  }

  void _onDragStart(DragStartDetails details) {
    final units = _toUnits(details.localPosition.dx);
    final offset = units - _thumb.value;
    // 조각 위에서 시작한 끌기만 조각을 옮긴다 — 다른 칸에서 시작하면 무시(탭으로 고른다).
    if (offset < 0 || offset > 1) return;
    _thumb.stop();
    setState(() => _grab = offset);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final grab = _grab;
    if (grab == null) return;
    _thumb.value = (_toUnits(details.localPosition.dx) - grab).clamp(
      0,
      widget.segments.length - 1,
    );
  }

  void _onDragEnd([DragEndDetails? _]) {
    if (_grab == null) return;
    setState(() => _grab = null);
    final index = _thumb.value.round();
    if (widget.segments[index].enabled) {
      _moveTo(index);
      _pick(index);
    } else {
      _moveTo(_selectedIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final a = AThemeData.of(context);
    final thumbColor = theme.brightness == Brightness.dark
        ? cs.surfaceContainerHighest
        : a.card;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : a.motion.short;
    final segments = widget.segments;

    Widget segment(int index, int highlighted) {
      final s = segments[index];
      final enabled = _active && s.enabled;
      final on = index == highlighted;
      final color = on ? cs.onSurface : cs.onSurfaceVariant;
      return Semantics(
        container: true,
        button: true,
        inMutuallyExclusiveGroup: true,
        selected: index == _selectedIndex,
        enabled: enabled,
        onTap: _active ? () => _pick(index) : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.38,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _minHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: a.spacing.md,
                vertical: a.spacing.sm,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: duration,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                    child: s.label,
                  ),
                  if (s.subtitle case final subtitle?)
                    DefaultTextStyle.merge(
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: a.textTertiary,
                      ),
                      child: subtitle,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final track = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: _active ? _onTapUp : null,
      onHorizontalDragStart: _active ? _onDragStart : null,
      onHorizontalDragUpdate: _active ? _onDragUpdate : null,
      onHorizontalDragEnd: _active ? _onDragEnd : null,
      onHorizontalDragCancel: _active ? _onDragEnd : null,
      child: Container(
        padding: const EdgeInsets.all(_trackPadding),
        decoration: BoxDecoration(
          color: widget.trackColor ?? a.sunken,
          borderRadius: BorderRadius.circular(a.radii.md),
        ),
        child: AnimatedBuilder(
          animation: _thumb,
          builder: (context, _) {
            final highlighted = _thumb.value.round().clamp(
              0,
              segments.length - 1,
            );
            return Stack(
              children: [
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final n = segments.length;
                      final width = (constraints.maxWidth - _gap * (n - 1)) / n;
                      return Stack(
                        children: [
                          Positioned(
                            left: _thumb.value * (width + _gap),
                            top: 0,
                            bottom: 0,
                            width: width,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: thumbColor,
                                borderRadius: BorderRadius.circular(
                                  a.radii.md - _trackPadding,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.shadow.withValues(alpha: 0.10),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // 칸 높이를 가장 높은 칸(부제 있는 칸)에 맞춘다.
                IntrinsicHeight(
                  child: Row(
                    spacing: _gap,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < segments.length; i++)
                        Expanded(child: segment(i, highlighted)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    // 폭이 열린 곳(Row 안 등)에서는 가장 긴 칸에 맞춘 같은 폭으로.
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.hasBoundedWidth ? track : IntrinsicWidth(child: track),
    );
  }
}
