import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../foundation/a_tokens.dart';

/// [glass] 값으로 그리는 유리 면 — [color] 에 `glass.opacity` 를 곱한 반투명 면 뒤로
/// 지나가는 내용을 `glass.blurSigma` 만큼 흐린다. 흐림은 [borderRadius] 모양(없으면 사각형) 안에서만.
///
/// 킷 내부용 — `AFloatingNavigationBar` · `AAppBar` 가 같은 모양으로 그리려고 나눠 쓴다.
///
/// 흐림은 `BackdropFilter.grouped` 라 위에 [BackdropGroup] 이 있으면(`AAdaptiveNavigation`) 그 안의
/// 유리 면들이 뒤 내용을 **한 번만** 흐려 나눠 쓴다(Impeller). 없으면 보통 `BackdropFilter` 와 같다.
class GlassSurface extends StatelessWidget {
  /// [child] 뒤에 유리 면을 깐다.
  const GlassSurface({
    super.key,
    required this.color,
    required this.glass,
    this.borderRadius,
    this.border,
    required this.child,
  });

  /// 면 색 — `glass.opacity` 가 곱해진다.
  final Color color;

  /// 불투명도 · 흐림.
  final AGlass glass;

  /// 면 · 흐림 모양. `null` 이면 사각형.
  final BorderRadius? borderRadius;

  /// 외곽선.
  final BoxBorder? border;

  /// 면 위 내용.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: color.a * glass.opacity),
        borderRadius: borderRadius,
        border: border,
      ),
      child: child,
    );
    if (glass.blurSigma > 0) {
      surface = BackdropFilter.grouped(
        filter: ImageFilter.blur(
          sigmaX: glass.blurSigma,
          sigmaY: glass.blurSigma,
        ),
        child: surface,
      );
    }
    return borderRadius == null
        ? ClipRect(child: surface)
        : ClipRRect(borderRadius: borderRadius!, child: surface);
  }
}
