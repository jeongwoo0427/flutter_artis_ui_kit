import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester,
  double width, {
  bool visible = true,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 800);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AThemeBuilder.light(
        tone: ATone.fromBrand(const Color(0xFF3182F6)),
      ),
      home: AFloatingNavigationScaffold(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Me'),
        ],
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        body: const Text('body'),
        navigationVisible: visible,
      ),
    ),
  );
}

void main() {
  testWidgets('floating bar at every width — phone and tablet alike', (
    tester,
  ) async {
    for (final width in [400.0, 1000.0, 1400.0]) {
      await _pump(tester, width);
      expect(find.byType(AFloatingNavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.text('body'), findsOneWidget);
    }
  });

  testWidgets('hidden bar slides down and ignores taps', (tester) async {
    await _pump(tester, 400, visible: false);
    await tester.pumpAndSettle();
    final slide = tester.widget<AnimatedSlide>(find.byType(AnimatedSlide));
    expect(slide.offset.dy, greaterThan(1));
    final ignore = tester.widget<IgnorePointer>(
      find
          .ancestor(
            of: find.byType(AFloatingNavigationBar),
            matching: find.byType(IgnorePointer),
          )
          .first,
    );
    expect(ignore.ignoring, isTrue);
  });

  testWidgets('tab screen glass bar and floating bar share one backdrop', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AThemeBuilder.light(
          tone: ATone.fromBrand(const Color(0xFF3182F6)),
        ),
        home: const AFloatingNavigationScaffold(
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(icon: Icon(Icons.person), label: 'Me'),
          ],
          selectedIndex: 0,
          body: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AAppBar(title: Text('Home')),
            body: SizedBox.expand(),
          ),
        ),
      ),
    );
    final keys = tester
        .renderObjectList<RenderBackdropFilter>(find.byType(BackdropFilter))
        .map((r) => r.backdropKey)
        .toList();
    expect(keys, hasLength(2));
    expect(keys.first, isNotNull);
    expect(keys.toSet(), hasLength(1));
  });
}
