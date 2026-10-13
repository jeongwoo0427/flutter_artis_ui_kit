import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AThemeBuilder.light(tone: ATone.fromBrand(const Color(0xFF3182F6))),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('tap and long press call back; tappable card is a button', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final events = <String>[];
    await tester.pumpWidget(
      _app(
        ACard(
          onTap: () => events.add('tap'),
          onLongPress: () => events.add('long'),
          child: const Text('Card'),
        ),
      ),
    );
    await tester.tap(find.text('Card'));
    await tester.longPress(find.text('Card'));
    expect(events, ['tap', 'long']);
    expect(find.byType(InkWell), findsOneWidget);
    expect(
      tester.getSemantics(find.byType(ACard)),
      matchesSemantics(
        isButton: true,
        hasTapAction: true,
        hasLongPressAction: true,
        isFocusable: true,
        hasFocusAction: true,
        children: [matchesSemantics(label: 'Card')],
      ),
    );
    handle.dispose();
  });

  testWidgets('non-tappable card has no InkWell and uses card defaults', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const ACard(child: Text('Plain'))));
    expect(find.byType(InkWell), findsNothing);

    final context = tester.element(find.byType(ACard));
    final a = AThemeData.of(context);
    final material = tester.widget<Material>(
      find.descendant(of: find.byType(ACard), matching: find.byType(Material)),
    );
    expect(material.color, a.card);
    expect(material.borderRadius, BorderRadius.circular(a.radii.xxl));
    final padding = tester.widget<Padding>(
      find.ancestor(of: find.text('Plain'), matching: find.byType(Padding)),
    );
    expect(padding.padding, EdgeInsets.all(a.spacing.card));
  });

  testWidgets('custom color and padding override defaults', (tester) async {
    const color = Colors.transparent;
    await tester.pumpWidget(
      _app(
        const ACard(color: color, padding: EdgeInsets.zero, child: Text('X')),
      ),
    );
    final material = tester.widget<Material>(
      find.descendant(of: find.byType(ACard), matching: find.byType(Material)),
    );
    expect(material.color, color);
  });
}
