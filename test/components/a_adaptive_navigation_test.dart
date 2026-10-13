import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, double width) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 800);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AThemeBuilder.light(
        tone: ATone.fromBrand(const Color(0xFF3182F6)),
      ),
      home: AAdaptiveNavigation(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Me'),
        ],
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        body: const Text('body'),
      ),
    ),
  );
}

void main() {
  testWidgets('compact width shows the floating bar', (tester) async {
    await _pump(tester, 400);
    expect(find.byType(AFloatingNavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('body'), findsOneWidget);
  });

  testWidgets('expanded width shows a navigation rail', (tester) async {
    await _pump(tester, 1000);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(AFloatingNavigationBar), findsNothing);
    expect(find.text('body'), findsOneWidget);
  });
}
