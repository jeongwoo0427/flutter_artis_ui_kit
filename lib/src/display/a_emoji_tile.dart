import 'package:flutter/material.dart';

import '../theme/a_theme_data.dart';

/// [AEmojiTile] 크기 — 정사각 40 / 44 / 52 / 64.
enum AEmojiTileSize {
  /// 40 — 촘촘한 목록.
  small,

  /// 44 — 기본 목록 행.
  medium,

  /// 52 — 카드 머리 · 빈 상태.
  large,

  /// 64 — 결과 · 상세 머리.
  hero,
}

/// 둥근 정사각 면 위의 이모지(또는 아이콘). 목록 행 앞 · 빈 상태 머리에 쓴다.
///
/// 장식이라 기본으로 스크린리더에서 숨긴다. 의미가 있으면 [semanticLabel] 을 준다.
///
/// ```dart
/// const AEmojiTile(emoji: '📚', size: AEmojiTileSize.large)
/// ```
class AEmojiTile extends StatelessWidget {
  /// 이모지 타일.
  const AEmojiTile({
    super.key,
    required String this.emoji,
    this.background,
    this.size = AEmojiTileSize.medium,
    this.semanticLabel,
  }) : icon = null,
       iconColor = null;

  /// 아이콘 타일.
  const AEmojiTile.icon({
    super.key,
    required IconData this.icon,
    this.background,
    this.iconColor,
    this.size = AEmojiTileSize.medium,
    this.semanticLabel,
  }) : emoji = null;

  /// 이모지 한 글자.
  final String? emoji;

  /// 아이콘.
  final IconData? icon;

  /// 면 색. 기본은 `AThemeData.sunken`.
  final Color? background;

  /// 아이콘 색. 기본은 `onSurfaceVariant`.
  final Color? iconColor;

  /// 크기.
  final AEmojiTileSize size;

  /// 스크린리더용 이름. 없으면 장식으로 보고 숨긴다.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    final (extent, radius) = switch (size) {
      AEmojiTileSize.small => (40.0, a.radii.md),
      AEmojiTileSize.medium => (44.0, a.radii.md),
      AEmojiTileSize.large => (52.0, a.radii.lg),
      AEmojiTileSize.hero => (64.0, a.radii.xl),
    };

    // 타일이 고정 크기 그림이라 내용도 글자 확대를 따르지 않는다(넘치지 않게).
    final content = icon != null
        ? Icon(
            icon,
            size: extent * 0.5,
            color: iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
          )
        : Text(
            emoji!,
            textScaler: TextScaler.noScaling,
            style: TextStyle(fontSize: extent * 0.55, height: 1),
          );

    final tile = SizedBox.square(
      dimension: extent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background ?? a.sunken,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(child: content),
      ),
    );

    if (semanticLabel == null) return ExcludeSemantics(child: tile);
    return Semantics(
      label: semanticLabel,
      image: true,
      child: ExcludeSemantics(child: tile),
    );
  }
}
