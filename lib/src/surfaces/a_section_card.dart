import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';
import 'a_card.dart';

/// 제목 줄이 있는 카드 — 제목(`titleLarge`) · 개수(primary) · 끝의 링크, 그 아래 [child].
///
/// ```dart
/// ASectionCard(
///   title: const Text('폴더'),
///   count: const Text('3'),
///   trailing: TextButton(onPressed: showAll, child: const Text('전체 ›')),
///   child: Column(children: rows),
/// )
/// ```
class ASectionCard extends StatelessWidget {
  /// 섹션 카드를 만든다.
  const ASectionCard({
    super.key,
    this.title,
    this.count,
    this.trailing,
    required this.child,
    this.padding,
  });

  /// 제목.
  final Widget? title;

  /// 제목 옆 개수 — primary 색.
  final Widget? count;

  /// 제목 줄 끝 — 보통 "전체 ›" 링크.
  final Widget? trailing;

  /// 본문.
  final Widget child;

  /// 카드 안쪽 여백. 기본 `spacing.card`.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    final cs = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.titleLarge;
    final hasHeader = title != null || count != null || trailing != null;
    return ACard(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: a.spacing.md,
        children: [
          if (hasHeader)
            Row(
              spacing: a.spacing.sm,
              children: [
                Expanded(
                  child: Row(
                    spacing: a.spacing.xs,
                    children: [
                      if (title != null)
                        Flexible(
                          child: Semantics(
                            header: true,
                            child: DefaultTextStyle.merge(
                              style: style,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: title!,
                            ),
                          ),
                        ),
                      if (count != null)
                        DefaultTextStyle.merge(
                          style: style?.copyWith(color: cs.primary),
                          child: count!,
                        ),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          child,
        ],
      ),
    );
  }
}

/// [ASectionHeader] 의 크기.
enum ASectionHeaderVariant {
  /// 화면 큰 제목 — `headlineLarge`.
  page,

  /// 목록 묶음 제목 — 작고 굵은 보조색.
  group,

  /// 폼 필드 라벨 — `labelLarge` · 본문 보조색.
  field,
}

/// 카드 밖의 섹션 제목. 스크린리더에는 제목(header)으로 알린다.
///
/// ```dart
/// const ASectionHeader('최근 푼 문제집')
/// ```
class ASectionHeader extends StatelessWidget {
  /// 섹션 제목을 만든다.
  const ASectionHeader(
    this.text, {
    super.key,
    this.variant = ASectionHeaderVariant.group,
    this.trailing,
  });

  /// 제목 글자.
  final String text;

  /// 크기.
  final ASectionHeaderVariant variant;

  /// 줄 끝 위젯 — 링크 · 버튼.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final style = switch (variant) {
      ASectionHeaderVariant.page => t.headlineLarge,
      ASectionHeaderVariant.group => t.bodySmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: a.textTertiary,
      ),
      ASectionHeaderVariant.field => t.labelLarge?.copyWith(
        color: cs.onSurfaceVariant,
      ),
    };
    return Row(
      spacing: a.spacing.sm,
      children: [
        Expanded(
          child: Semantics(header: true, child: Text(text, style: style)),
        ),
        ?trailing,
      ],
    );
  }
}
