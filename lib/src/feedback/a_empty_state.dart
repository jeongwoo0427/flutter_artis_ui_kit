import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

/// 목록이 비었을 때 보여 주는 안내(아이콘 · 제목 · 설명 · 행동).
///
/// 화면을 채우는 기본형은 가운데 정렬된다. sliver 목록 안에서는
/// `SliverFillRemaining(hasScrollBody: false, child: AEmptyState(...))` 로 감싼다.
/// 카드 안의 작은 빈 미리보기는 [AEmptyState.inline].
///
/// ```dart
/// AEmptyState(
///   icon: const AEmojiTile(emoji: '📭', size: AEmojiTileSize.large),
///   title: const Text('아직 문제가 없어요'),
///   message: const Text('첫 문제를 만들어 보세요'),
///   action: AButton(onPressed: create, child: const Text('문제 만들기')),
/// )
/// ```
class AEmptyState extends StatelessWidget {
  /// 화면 · 영역을 채우는 빈 상태.
  const AEmptyState({
    super.key,
    this.icon,
    required this.title,
    this.message,
    this.action,
  }) : _inline = false;

  /// 카드 안에 넣는 빈 미리보기 — 한 단계 들어간 둥근 면 위에 같은 내용을 둔다.
  const AEmptyState.inline({
    super.key,
    this.icon,
    required this.title,
    this.message,
    this.action,
  }) : _inline = true;

  /// 위쪽 그림(보통 `AEmojiTile`).
  final Widget? icon;

  /// 제목.
  final Widget title;

  /// 제목 아래 설명.
  final Widget? message;

  /// 맨 아래 행동(보통 버튼).
  final Widget? action;

  final bool _inline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final a = AThemeData.of(context);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[icon!, SizedBox(height: a.spacing.md)],
        Semantics(
          header: true,
          child: DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            style: (_inline ? text.titleMedium : text.titleLarge)!.copyWith(
              fontWeight: FontWeight.w800,
            ),
            child: title,
          ),
        ),
        if (message != null) ...[
          SizedBox(height: a.spacing.xs),
          DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            style: text.bodyMedium!.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            child: message!,
          ),
        ],
        if (action != null) ...[SizedBox(height: a.spacing.lg), action!],
      ],
    );

    if (_inline) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: a.sunken,
          borderRadius: BorderRadius.circular(a.radii.xxl),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: a.spacing.lg,
            vertical: a.spacing.xl,
          ),
          child: Center(heightFactor: 1, child: content),
        ),
      );
    }
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: a.spacing.screen,
          vertical: a.spacing.xxl,
        ),
        child: content,
      ),
    );
  }
}
