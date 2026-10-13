import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _fadeHeight = 24;

/// [ABottomBar] 위쪽 경계를 어떻게 그릴지.
enum ABottomBarEdge {
  /// 경계 없음.
  none,

  /// 1px 선(`colorScheme.outlineVariant`).
  line,

  /// 위로 [ABottomBar.fadeHeight] 만큼 바 색으로 서서히 덮는다 — 스크롤 내용이 흐려지며 사라진다.
  /// 내용이 그 뒤로 지나가려면 `Scaffold(extendBody: true)` 나 `Stack` 이어야 한다.
  fade,
}

/// 화면 맨 아래에 붙는 버튼 바 — 주 버튼 하나, 버튼 여러 개, 아이콘 동작 + 주 버튼(`ASelectionBar`) 모두 이 틀을 쓴다.
///
/// `Scaffold.bottomNavigationBar` 나 `Stack` 의 아래쪽에 둔다. [child] 는 최대 [maxContentWidth] 폭으로 가운데에 놓이고
/// 그 폭을 꽉 채운다 — 버튼 하나면 꽉 찬 버튼, 여러 개면 `Expanded` 를 쓴 `Row`.
/// 아래는 홈 인디케이터를 비켜 간다(`SafeArea`).
///
/// ```dart
/// Scaffold(
///   body: ...,
///   bottomNavigationBar: ABottomBar(
///     child: Row(children: [
///       Expanded(child: FilledButton.tonal(onPressed: save, child: const Text('저장'))),
///       Expanded(child: FilledButton(onPressed: submit, child: const Text('제출'))),
///     ]),
///   ),
/// )
/// ```
class ABottomBar extends StatelessWidget {
  /// 하단 바를 만든다.
  const ABottomBar({
    super.key,
    required this.child,
    this.backgroundColor,
    this.edge = ABottomBarEdge.line,
    this.fadeHeight = _fadeHeight,
    this.padding,
    this.maxContentWidth = 640,
  });

  /// 버튼(들).
  final Widget child;

  /// 바 면 색. 기본 `AThemeData.card`(흰 면). 페이지와 이어 보이게 하려면 `scaffoldBackgroundColor`.
  final Color? backgroundColor;

  /// 위쪽 경계 — 선 · 페이드 · 없음.
  final ABottomBarEdge edge;

  /// [ABottomBarEdge.fade] 의 높이.
  final double fadeHeight;

  /// [child] 둘레 여백. 기본 좌우 `spacing.screen` · 위 `spacing.md`(아래는 안전 영역 + `spacing.md`).
  final EdgeInsetsGeometry? padding;

  /// [child] 의 최대 폭.
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    final background = backgroundColor ?? a.card;

    final bar = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: edge == ABottomBarEdge.line
            ? Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              )
            : null,
      ),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: a.spacing.md),
        child: Padding(
          padding:
              padding ??
              EdgeInsetsDirectional.only(
                start: a.spacing.screen,
                end: a.spacing.screen,
                top: a.spacing.md,
              ),
          child: Align(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: SizedBox(width: double.infinity, child: child),
            ),
          ),
        ),
      ),
    );

    // 머티리얼 면 — 잉크 · 버튼이 바 위에 그려지게.
    final surface = Material(type: MaterialType.transparency, child: bar);
    if (edge != ABottomBarEdge.fade) return surface;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IgnorePointer(
          child: Container(
            height: fadeHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [background.withValues(alpha: 0), background],
              ),
            ),
          ),
        ),
        surface,
      ],
    );
  }
}
