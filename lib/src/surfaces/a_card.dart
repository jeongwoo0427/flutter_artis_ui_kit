import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

/// 평평한 카드 — `AThemeData.card` 면 · `radii.xxl` 모서리 · 테두리와 그림자 없음.
///
/// [onTap] 이나 [onLongPress] 가 있으면 눌리는 카드가 된다(잉크 · 눌림 축소 · 버튼 Semantics).
/// 안의 `AListRow` 같은 잉크가 카드 면 위에 보이도록 항상 [Material] 로 그린다.
///
/// ```dart
/// ACard(onTap: open, child: Text(workbook.title))
/// ```
class ACard extends StatefulWidget {
  /// 카드를 만든다.
  const ACard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.color,
  });

  /// 내용.
  final Widget child;

  /// 탭했을 때.
  final VoidCallback? onTap;

  /// 길게 눌렀을 때.
  final VoidCallback? onLongPress;

  /// 안쪽 여백. 기본 `spacing.card`.
  final EdgeInsetsGeometry? padding;

  /// 면 색. 기본 `AThemeData.card`.
  final Color? color;

  @override
  State<ACard> createState() => _ACardState();
}

class _ACardState extends State<ACard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    final radius = BorderRadius.circular(a.radii.xxl);
    final tappable = widget.onTap != null || widget.onLongPress != null;
    final content = Padding(
      padding: widget.padding ?? EdgeInsets.all(a.spacing.card),
      child: widget.child,
    );
    final card = Material(
      color: widget.color ?? a.card,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: tappable
          ? InkWell(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              onHighlightChanged: (v) => setState(() => _pressed = v),
              borderRadius: radius,
              child: content,
            )
          : content,
    );
    if (!tappable) return card;

    final animate = !MediaQuery.disableAnimationsOf(context);
    return Semantics(
      button: true,
      container: true,
      child: AnimatedScale(
        scale: _pressed && animate ? a.motion.pressScale : 1,
        duration: animate ? a.motion.short : Duration.zero,
        child: card,
      ),
    );
  }
}
