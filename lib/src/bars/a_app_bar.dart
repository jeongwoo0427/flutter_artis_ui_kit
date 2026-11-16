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
/// 그렇지 않은 Scaffold 에서는 바 뒤에 흐릴 내용이 없으므로 **흐리지 않고 불투명하게** 그린다
/// (보이는 것은 같고, 흐림 비용을 아낀다).
///
/// 유리와 아래 테두리(하단 탭 알약과 같은 [AGlass] 테두리)는 **본문이 바 밑으로 스크롤됐을 때만** 켜진다 —
/// Material [AppBar] 의 scrolled-under 와 같은 방식으로 Scaffold 의 스크롤 알림을 듣는다(맨 위로 돌아오면 꺼진다).
/// 맨 위에서는 바 뒤가 본문의 위 여백(페이지)이라 불투명한 페이지색과 똑같아 보이는데, 흐림을 켜 두면
/// 바 바로 아래 내용(예: 검은 탭)의 색까지 끌어와 바 밑단이 번진다. 그래서 맨 위에서는 불투명하게 그리고 흐림 비용도 아낀다.
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
class AAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<AAppBar> createState() => _AAppBarState();
}

class _AAppBarState extends State<AAppBar> {
  ScrollNotificationObserverState? _observer;

  /// 본문이 바 밑으로 스크롤돼 있는지 — Material [AppBar] 의 scrolled-under 와 같은 판정.
  bool _scrolledUnder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _observer?.removeListener(_handleScroll);
    _observer = ScrollNotificationObserver.maybeOf(context);
    _observer?.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _observer?.removeListener(_handleScroll);
    _observer = null;
    super.dispose();
  }

  void _handleScroll(ScrollNotification notification) {
    if (notification is! ScrollUpdateNotification ||
        !defaultScrollNotificationPredicate(notification)) {
      return;
    }
    final metrics = notification.metrics;
    final scrolledUnder = switch (metrics.axisDirection) {
      AxisDirection.down => metrics.extentBefore > 0,
      AxisDirection.up => metrics.extentAfter > 0,
      // 가로 스크롤은 상태를 바꾸지 않는다(2D 스크롤의 가로 알림 포함).
      AxisDirection.left || AxisDirection.right => _scrolledUnder,
    };
    if (scrolledUnder != _scrolledUnder) {
      setState(() => _scrolledUnder = scrolledUnder);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final a = AThemeData.of(context);
    final glass = widget.glass ?? a.glass;
    final color =
        widget.backgroundColor ?? theme.appBarTheme.backgroundColor ?? a.page;
    // 본문이 바 뒤로 오지 않거나 아직 바 밑으로 스크롤되지 않았으면 유리를 끈다 —
    // 페이지 위 반투명 페이지색은 불투명과 같아 보이고, 흐림만 바 아래 내용을 끌어와 번진다.
    final behind =
        Scaffold.maybeOf(context)?.widget.extendBodyBehindAppBar ?? true;
    final glassOn = behind && _scrolledUnder;
    // 바 자체는 투명이라 AppBar 가 상태 표시줄 글자색을 정하지 못한다 — 면 색 기준으로 정해 준다.
    final iconBrightness =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Brightness.light
        : Brightness.dark;

    return AppBar(
      leading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      title: widget.title,
      actions: widget.actions,
      bottom: widget.bottom,
      centerTitle: widget.centerTitle,
      titleSpacing: widget.titleSpacing,
      leadingWidth: widget.leadingWidth,
      foregroundColor: widget.foregroundColor,
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
      // 테두리는 유리 면 밖에 둔다 — 유리를 켜고 끌 때 면 쪽 위젯 트리가 바뀌어도 테두리의 페이드가 끊기지 않게.
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          GlassSurface(
            color: color,
            opacity: glassOn ? glass.appBarOpacity : 1,
            glass: glassOn ? glass : AGlass.none,
            child: const SizedBox.shrink(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: _scrolledUnder && glass.borderWidth > 0 ? 1 : 0,
              duration: a.motion.medium,
              child: SizedBox(
                height: glass.borderWidth,
                width: double.infinity,
                child: ColoredBox(
                  color: glassBorderColor(glass, theme.colorScheme),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
