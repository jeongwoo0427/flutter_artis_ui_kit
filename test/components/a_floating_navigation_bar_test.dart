import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

final _theme = AThemeBuilder.light(
  tone: ATone.fromBrand(const Color(0xFF3182F6)),
);

const _destinations = [
  NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
  NavigationDestination(icon: Icon(Icons.question_mark), label: 'Bank'),
  NavigationDestination(icon: Icon(Icons.quiz), label: 'Quiz'),
];

Widget _app({
  required int selected,
  ValueChanged<int>? onSelected,
  Color? backgroundColor,
  AGlass? glass,
}) {
  return MaterialApp(
    theme: _theme,
    home: Scaffold(
      extendBody: true,
      bottomNavigationBar: AFloatingNavigationBar(
        destinations: _destinations,
        selectedIndex: selected,
        onDestinationSelected: onSelected,
        backgroundColor: backgroundColor,
        glass: glass,
      ),
    ),
  );
}

BoxDecoration _pillDecoration(WidgetTester tester) =>
    tester
            .widget<DecoratedBox>(
              find
                  .descendant(
                    of: find.byType(AFloatingNavigationBar),
                    matching: find.byType(DecoratedBox),
                  )
                  .first,
            )
            .decoration
        as BoxDecoration;

double _cursorStart(WidgetTester tester) => tester
    .widget<AnimatedPositionedDirectional>(
      find.byType(AnimatedPositionedDirectional),
    )
    .start!;

void main() {
  testWidgets('renders labels and reports taps, including the selected one', (
    tester,
  ) async {
    final taps = <int>[];
    await tester.pumpWidget(_app(selected: 0, onSelected: taps.add));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Bank'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);

    await tester.tap(find.text('Quiz'));
    await tester.tap(find.text('Home'));
    expect(taps, [2, 0]);
  });

  testWidgets('selected item exposes selected button semantics', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_app(selected: 1, onSelected: (_) {}));

    expect(
      tester.getSemantics(find.text('Bank')),
      isSemantics(
        label: 'Bank',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        isEnabled: true,
        hasEnabledState: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.text('Home')),
      isSemantics(label: 'Home', isButton: true, isSelected: false),
    );
    handle.dispose();
  });

  testWidgets('tap target is at least 48 high', (tester) async {
    await tester.pumpWidget(_app(selected: 0, onSelected: (_) {}));
    final size = tester.getSize(find.byType(InkWell).first);
    expect(size.height, greaterThanOrEqualTo(48));
    expect(size.width, 64);

    // 지금 앱과 같은 알약 크기: 항목 3 × 64 + 사이 2 × 1 + 좌우 20 × 2, 높이 66.
    final pill = find.descendant(
      of: find.byType(AFloatingNavigationBar),
      matching: find.byType(DecoratedBox),
    );
    expect(tester.getSize(pill.first), const Size(3 * 64 + 2 + 40, 66));
    expect(AFloatingNavigationBar.height, 66);
  });

  testWidgets('cursor moves to the selected item', (tester) async {
    await tester.pumpWidget(_app(selected: 0));
    final first = _cursorStart(tester);
    await tester.pumpWidget(_app(selected: 2));
    await tester.pumpAndSettle();
    expect(_cursorStart(tester) - first, 2 * (64 + 1));
  });

  testWidgets('null callback disables items', (tester) async {
    await tester.pumpWidget(_app(selected: 0));
    final ink = tester.widget<InkWell>(find.byType(InkWell).first);
    expect(ink.onTap, isNull);
  });

  testWidgets('glass by default — the theme glass on the card color', (
    tester,
  ) async {
    await tester.pumpWidget(_app(selected: 0));
    final a = _theme.extension<AThemeData>()!;
    expect(
      _pillDecoration(tester).color,
      a.card.withValues(alpha: a.glass.navigationBarOpacity),
    );
    final filter = tester.widget<BackdropFilter>(find.byType(BackdropFilter));
    expect(
      filter.filter,
      ImageFilter.blur(sigmaX: a.glass.blurSigma, sigmaY: a.glass.blurSigma),
    );
  });

  testWidgets('color and glass are customizable; AGlass.none is opaque', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        selected: 0,
        backgroundColor: Colors.amber,
        glass: const AGlass(navigationBarOpacity: 0.5, blurSigma: 6),
      ),
    );
    expect(_pillDecoration(tester).color, Colors.amber.withValues(alpha: 0.5));
    expect(
      tester.widget<BackdropFilter>(find.byType(BackdropFilter)).filter,
      ImageFilter.blur(sigmaX: 6, sigmaY: 6),
    );

    await tester.pumpWidget(_app(selected: 0, glass: AGlass.none));
    expect(find.byType(BackdropFilter), findsNothing);
    expect(_pillDecoration(tester).color, _theme.extension<AThemeData>()!.card);
  });

  testWidgets('outline comes from the glass border', (tester) async {
    await tester.pumpWidget(_app(selected: 0));
    final cs = _theme.colorScheme;
    final border = _pillDecoration(tester).border! as Border;
    expect(border.top.color, cs.onSurface.withValues(alpha: 0.08));
    expect(border.top.width, 1);

    await tester.pumpWidget(
      _app(
        selected: 0,
        glass: const AGlass(borderColor: Colors.amber, borderWidth: 2),
      ),
    );
    final custom = _pillDecoration(tester).border! as Border;
    expect(custom.top.color, Colors.amber);
    expect(custom.top.width, 2);

    await tester.pumpWidget(
      _app(selected: 0, glass: const AGlass(borderWidth: 0)),
    );
    expect(_pillDecoration(tester).border, isNull);
  });
}
