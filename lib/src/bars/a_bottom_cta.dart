import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

const double _maxContentWidth = 640;
const double _fadeHeight = 24;

/// 화면 맨 아래에 붙는 주 행동 버튼 자리.
///
/// `Scaffold.bottomNavigationBar` 나 `Stack` 의 아래쪽에 둔다. [child] 는 최대 640 폭으로 가운데에 놓이고
/// 그 폭을 꽉 채운다 — 버튼 하나면 꽉 찬 버튼, 여러 개면 `Expanded` 를 쓴 `Row`.
/// [fade] 면 위쪽 24 만큼 페이지색으로 서서히 덮어 스크롤 내용이 자연스럽게 사라진다
/// (내용이 그 뒤로 지나가려면 `Scaffold(extendBody: true)` 나 `Stack` 이어야 한다).
///
/// ```dart
/// Scaffold(
///   extendBody: true,
///   body: ...,
///   bottomNavigationBar: ABottomCta(
///     child: FilledButton(onPressed: submit, child: const Text('제출하기')),
///   ),
/// )
/// ```
class ABottomCta extends StatelessWidget {
  /// 하단 버튼 자리를 만든다.
  const ABottomCta({super.key, required this.child, this.fade = true});

  /// 버튼(들).
  final Widget child;

  /// 위쪽 페이드를 그린다.
  final bool fade;

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).scaffoldBackgroundColor;
    final spacing = AThemeData.of(context).spacing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (fade)
          IgnorePointer(
            child: Container(
              height: _fadeHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [background.withValues(alpha: 0), background],
                ),
              ),
            ),
          ),
        ColoredBox(
          color: background,
          child: SafeArea(
            top: false,
            minimum: EdgeInsets.only(bottom: spacing.md),
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: spacing.screen,
                end: spacing.screen,
                top: spacing.md,
              ),
              child: Align(
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                  child: SizedBox(width: double.infinity, child: child),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
