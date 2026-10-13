import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

const _glass = AGlass(opacity: 0.5, blurSigma: 8);
final _theme = AThemeBuilder.light(
  tone: ATone.fromBrand(const Color(0xFF3182F6)),
  glass: _glass,
);

Widget _app(PreferredSizeWidget appBar, {ThemeData? theme}) => MaterialApp(
  theme: theme ?? _theme,
  home: Scaffold(
    extendBodyBehindAppBar: true,
    appBar: appBar,
    body: const SizedBox.expand(),
  ),
);

Color? _surfaceColor(WidgetTester tester) =>
    (tester
                .widget<DecoratedBox>(
                  find
                      .descendant(
                        of: find.byType(AAppBar),
                        matching: find.byType(DecoratedBox),
                      )
                      .first,
                )
                .decoration
            as BoxDecoration)
        .color;

void main() {
  testWidgets('glass from the theme — translucent page color + blur', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const AAppBar(title: Text('Bank'))));

    expect(find.text('Bank'), findsOneWidget);
    final page = _theme.extension<AThemeData>()!.page;
    expect(_surfaceColor(tester), page.withValues(alpha: 0.5));
    expect(
      tester.widget<BackdropFilter>(find.byType(BackdropFilter)).filter,
      ImageFilter.blur(sigmaX: 8, sigmaY: 8),
    );
    // 바 자체는 투명 — 면은 유리가 그린다.
    expect(
      tester.widget<AppBar>(find.byType(AppBar)).backgroundColor,
      Colors.transparent,
    );
  });

  testWidgets('same glass as the bottom navigation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: _theme,
        home: Scaffold(
          appBar: const AAppBar(title: Text('Bank')),
          bottomNavigationBar: AFloatingNavigationBar(
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Me'),
            ],
            selectedIndex: 0,
          ),
        ),
      ),
    );
    final filters = tester
        .widgetList<BackdropFilter>(find.byType(BackdropFilter))
        .map((f) => f.filter)
        .toSet();
    expect(filters, {ImageFilter.blur(sigmaX: 8, sigmaY: 8)});
  });

  testWidgets('bottom row is covered; height includes it', (tester) async {
    const bar = AAppBar(
      title: Text('Bank'),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: Text('crumbs'),
      ),
    );
    expect(bar.preferredSize.height, kToolbarHeight + 44);
    await tester.pumpWidget(_app(bar));
    expect(find.text('crumbs'), findsOneWidget);
  });

  testWidgets('status bar icons follow the surface, not the transparent bar', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const AAppBar(title: Text('Bank'))));
    expect(
      tester
          .widget<AppBar>(find.byType(AppBar))
          .systemOverlayStyle
          ?.statusBarIconBrightness,
      Brightness.dark,
    );

    await tester.pumpWidget(
      _app(
        const AAppBar(title: Text('Bank')),
        theme: AThemeBuilder.dark(
          tone: ATone.fromBrand(const Color(0xFF3182F6)),
        ),
      ),
    );
    await tester.pumpAndSettle(); // 테마 전환 애니메이션
    expect(
      tester
          .widget<AppBar>(find.byType(AppBar))
          .systemOverlayStyle
          ?.statusBarIconBrightness,
      Brightness.light,
    );
  });

  testWidgets('AGlass.none draws an opaque bar without blur', (tester) async {
    await tester.pumpWidget(
      _app(const AAppBar(title: Text('Bank'), glass: AGlass.none)),
    );
    expect(find.byType(BackdropFilter), findsNothing);
    expect(_surfaceColor(tester), _theme.extension<AThemeData>()!.page);
  });
}
