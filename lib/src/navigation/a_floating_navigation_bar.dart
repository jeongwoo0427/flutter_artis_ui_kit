import 'package:flutter/material.dart';

import '../foundation/a_tokens.dart';
import '../surfaces/glass_surface.dart';
import '../theme/a_theme_data.dart';

// 알약 치수 — 지금 앱의 하단 탭과 같은 값(DESIGN_RENEWAL_TASK §4A.5).
const double _itemWidth = 64;
const double _itemSpacing = 1;
const double _iconAreaHeight = 32;
const double _iconSize = 24;
const double _labelGap = 2;
const double _labelSize = 11;
const double _paddingTop = 8;
const double _paddingBottom = 8;
const double _paddingHorizontal = 20;
const double _cursorSize = 5;
const double _bottomMargin = 16;

/// 화면 아래에 떠 있는 알약 모양 하단 탭. API 는 Material [NavigationBar] 와 같다.
///
/// 선택한 항목 위에 작은 점 커서가 움직인다. 이미 선택된 항목을 눌러도
/// [onDestinationSelected] 가 같은 index 로 불린다(맨 위로 · 루트로 처리용).
///
/// 알약은 **유리처럼** 그린다 — 반투명 면 뒤로 지나가는 내용을 흐려서, 어떤 내용 위에서도
/// 탭이 떠 보이고 뒤 글자와 섞이지 않는다. 불투명도 · 흐림은 테마의 [AThemeData.glass] 로
/// `AAppBar` 와 함께 정하고, 이 바만 다르게 하려면 [glass] 를 준다(끄려면 [AGlass.none]).
///
/// 본문이 알약 뒤까지 이어지게 `Scaffold(extendBody: true)` 의 `bottomNavigationBar` 에 두고,
/// 본문 아래 여백은 `MediaQuery.paddingOf(context).bottom` 을 쓴다.
///
/// ```dart
/// Scaffold(
///   extendBody: true,
///   body: body,
///   bottomNavigationBar: AFloatingNavigationBar(
///     destinations: const [
///       NavigationDestination(icon: Icon(Icons.home_rounded), label: '홈'),
///       NavigationDestination(icon: Icon(Icons.person), label: '내 정보'),
///     ],
///     selectedIndex: index,
///     onDestinationSelected: (i) => setState(() => index = i),
///   ),
/// )
/// ```
class AFloatingNavigationBar extends StatelessWidget {
  /// [destinations] 중 [selectedIndex] 번째를 선택 상태로 그린다.
  const AFloatingNavigationBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
    this.backgroundColor,
    this.glass,
  }) : assert(destinations.length >= 2),
       assert(0 <= selectedIndex && selectedIndex < destinations.length);

  /// 알약 자체의 높이(바닥 여백 · 안전 영역 제외). 여백을 직접 계산해야 할 때만 쓴다.
  static const double height =
      _paddingTop +
      _cursorSize +
      _iconAreaHeight +
      _labelGap +
      _labelSize +
      _paddingBottom;

  /// 탭 항목 — `icon` · `selectedIcon` · `label` · `tooltip` · `enabled` 를 쓴다.
  final List<NavigationDestination> destinations;

  /// 선택된 항목의 index.
  final int selectedIndex;

  /// 항목을 눌렀을 때. `null` 이면 모든 항목이 비활성.
  final ValueChanged<int>? onDestinationSelected;

  /// 알약 면 색 — [glass] 의 불투명도가 곱해진다. `null` 이면 카드색(다크는 한 단계 밝은 면).
  final Color? backgroundColor;

  /// 유리 면 값. `null` 이면 테마의 [AThemeData.glass].
  final AGlass? glass;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final a = AThemeData.of(context);
    final background =
        backgroundColor ??
        (theme.brightness == Brightness.dark ? cs.surfaceContainer : a.card);
    final shape = BorderRadius.circular(a.radii.full);
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : a.motion.medium;

    return SafeArea(
      minimum: const EdgeInsets.only(bottom: _bottomMargin),
      maintainBottomViewPadding: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomPaint(
            // 그림자는 알약 바깥에만 — 반투명 면 아래로 비치면 유리가 탁해진다.
            painter: _OuterShadowPainter(
              borderRadius: shape,
              shadow: BoxShadow(
                color: cs.shadow.withValues(alpha: 0.14),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ),
            child: GlassSurface(
              color: background,
              glass: glass ?? a.glass,
              borderRadius: shape,
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.08)),
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: _paddingHorizontal,
                  ),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: _itemSpacing,
                        children: [
                          for (var i = 0; i < destinations.length; i++)
                            _Item(
                              destination: destinations[i],
                              selected: i == selectedIndex,
                              onTap:
                                  onDestinationSelected == null ||
                                      !destinations[i].enabled
                                  ? null
                                  : () => onDestinationSelected!(i),
                            ),
                        ],
                      ),
                      AnimatedPositionedDirectional(
                        duration: duration,
                        curve: Curves.easeInOut,
                        top: _paddingTop,
                        start:
                            selectedIndex * (_itemWidth + _itemSpacing) +
                            (_itemWidth - _cursorSize) / 2,
                        width: _cursorSize,
                        height: _cursorSize,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: cs.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [borderRadius] 모양 바깥에만 [shadow] 를 그린다.
class _OuterShadowPainter extends CustomPainter {
  const _OuterShadowPainter({required this.borderRadius, required this.shadow});

  final BorderRadius borderRadius;
  final BoxShadow shadow;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = borderRadius.toRRect(Offset.zero & size);
    canvas.save();
    canvas.clipPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(rrect.outerRect.inflate(shadow.blurRadius * 2 + 40))
        ..addRRect(rrect),
    );
    canvas.drawRRect(
      rrect.shift(shadow.offset).inflate(shadow.spreadRadius),
      shadow.toPaint(),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_OuterShadowPainter old) =>
      old.borderRadius != borderRadius || old.shadow != shadow;
}

/// 항목 하나. 커서 줄과 위아래 여백까지 눌리는 영역이라 높이가 48 을 넘는다.
class _Item extends StatelessWidget {
  const _Item({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final NavigationDestination destination;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;
    final icon = selected
        ? destination.selectedIcon ?? destination.icon
        : destination.icon;

    Widget item = MergeSemantics(
      child: Semantics(
        button: true,
        selected: selected,
        enabled: onTap != null,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AThemeData.of(context).radii.md),
          child: SizedBox(
            width: _itemWidth,
            child: Padding(
              padding: const EdgeInsets.only(
                top: _paddingTop + _cursorSize,
                bottom: _paddingBottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: _iconAreaHeight,
                    child: Center(
                      child: IconTheme.merge(
                        data: IconThemeData(size: _iconSize, color: color),
                        child: icon,
                      ),
                    ),
                  ),
                  const SizedBox(height: _labelGap),
                  Text(
                    destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: _labelSize,
                      height: 1.0,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    final tooltip = destination.tooltip;
    if (tooltip != null) item = Tooltip(message: tooltip, child: item);
    return item;
  }
}
