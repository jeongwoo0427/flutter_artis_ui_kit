import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundation/a_tokens.dart';
import '../surfaces/glass_surface.dart';
import '../theme/a_theme_data.dart';

/// 유리처럼 그리는 상단 바 — Material [AppBar] 와 같은 자리에 쓰고, 면이 반투명해서
/// 바 뒤로 지나가는 내용이 흐려져 비친다. 불투명도 · 흐림은 하단 탭과 같은 [AThemeData.glass].
///
/// 내용이 바 뒤로 지나가게 하려면 `Scaffold(extendBodyBehindAppBar: true)` 로 두고, 본문 위 여백은
/// 본문 안쪽 context 의 `MediaQuery.paddingOf(context).top`(바 높이 + 상태 표시줄)을 쓴다.
/// 그렇게 하지 않으면 바 뒤가 페이지라서 지금의 불투명 바와 똑같이 보인다.
///
/// ```dart
/// Scaffold(
///   extendBodyBehindAppBar: true,
///   appBar: AAppBar(title: const Text('문제은행')),
///   body: Builder(
///     builder: (context) => ListView(
///       padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
///       children: rows,
///     ),
///   ),
/// )
/// ```
class AAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 인자는 같은 이름의 [AppBar] 인자와 같다.
  const AAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.bottom,
    this.centerTitle,
    this.titleSpacing,
    this.leadingWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.glass,
  });

  /// [AppBar.leading].
  final Widget? leading;

  /// [AppBar.automaticallyImplyLeading].
  final bool automaticallyImplyLeading;

  /// [AppBar.title].
  final Widget? title;

  /// [AppBar.actions].
  final List<Widget>? actions;

  /// [AppBar.bottom] — 유리 면이 이 줄까지 덮는다.
  final PreferredSizeWidget? bottom;

  /// [AppBar.centerTitle].
  final bool? centerTitle;

  /// [AppBar.titleSpacing].
  final double? titleSpacing;

  /// [AppBar.leadingWidth].
  final double? leadingWidth;

  /// 면 색 — [glass] 의 불투명도가 곱해진다. `null` 이면 테마 앱바 색(페이지색).
  final Color? backgroundColor;

  /// [AppBar.foregroundColor].
  final Color? foregroundColor;

  /// 유리 면 값. `null` 이면 테마의 [AThemeData.glass].
  final AGlass? glass;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = AThemeData.of(context);
    final color =
        backgroundColor ?? theme.appBarTheme.backgroundColor ?? a.page;
    // 바 자체는 투명이라 AppBar 가 상태 표시줄 글자색을 정하지 못한다 — 면 색 기준으로 정해 준다.
    final iconBrightness =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      bottom: bottom,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      foregroundColor: foregroundColor,
      backgroundColor: Colors.transparent,
      systemOverlayStyle:
          theme.appBarTheme.systemOverlayStyle ??
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: iconBrightness,
            statusBarBrightness: iconBrightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
          ),
      flexibleSpace: GlassSurface(
        color: color,
        glass: glass ?? a.glass,
        child: const SizedBox.expand(),
      ),
    );
  }
}
