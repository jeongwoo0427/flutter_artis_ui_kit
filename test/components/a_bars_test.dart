import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

final _theme = AThemeBuilder.light(
  tone: ATone.fromBrand(const Color(0xFF3182F6)),
);

Widget _app(Widget bar) => MaterialApp(
  theme: _theme,
  home: Scaffold(body: const SizedBox.expand(), bottomNavigationBar: bar),
);

void main() {
  group('ABottomCta', () {
    testWidgets('child fills width but at most 640 on a wide surface', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1200, 800);
      addTearDown(tester.view.reset);

      const key = Key('cta');
      await tester.pumpWidget(
        _app(
          ABottomCta(
            child: FilledButton(
              key: key,
              onPressed: () {},
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byKey(key)).width, 640);
      expect(tester.getCenter(find.byKey(key)).dx, 600);
    });

    testWidgets('child fills a narrow surface minus the side margins', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 700);
      addTearDown(tester.view.reset);

      const key = Key('cta');
      await tester.pumpWidget(
        _app(
          ABottomCta(
            fade: false,
            child: FilledButton(
              key: key,
              onPressed: () {},
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      final margin = AThemeData.of(
        tester.element(find.byKey(key)),
      ).spacing.screen;
      expect(tester.getSize(find.byKey(key)).width, 360 - margin * 2);
      // 페이지 높이를 다 먹지 않는다.
      expect(tester.getSize(find.byType(ABottomCta)).height, lessThan(200));
    });
  });

  group('ASelectionBar', () {
    testWidgets('actions call back; null onPressed is disabled; note shows', (
      tester,
    ) async {
      final taps = <String>[];
      await tester.pumpWidget(
        _app(
          ASelectionBar(
            note: const Text('1 folder skipped'),
            actions: [
              ASelectionBarAction(
                icon: const Icon(Icons.drive_file_move),
                label: 'Move',
                onPressed: () => taps.add('move'),
              ),
              ASelectionBarAction(
                icon: const Icon(Icons.delete),
                label: 'Delete',
                onPressed: () => taps.add('delete'),
                destructive: true,
              ),
              const ASelectionBarAction(
                icon: Icon(Icons.copy),
                label: 'Copy',
                onPressed: null,
              ),
            ],
            primary: FilledButton(
              onPressed: () => taps.add('primary'),
              child: const Text('Play 2'),
            ),
          ),
        ),
      );

      expect(find.text('1 folder skipped'), findsOneWidget);
      await tester.tap(find.text('Move'));
      await tester.tap(find.text('Delete'));
      await tester.tap(find.text('Copy'));
      await tester.tap(find.text('Play 2'));
      expect(taps, ['move', 'delete', 'primary']);

      final cs = _theme.colorScheme;
      Color? color(String s) => tester.widget<Text>(find.text(s)).style?.color;
      expect(color('Delete'), cs.error);
      expect(color('Copy'), cs.outline);
      expect(color('Move'), isNot(cs.error));

      expect(
        tester.getSemantics(find.text('Copy')),
        matchesSemantics(isButton: true, hasEnabledState: true, label: 'Copy'),
      );
      expect(
        tester.getSize(
          find.ancestor(of: find.text('Move'), matching: find.byType(InkWell)),
        ),
        const Size(62, 52),
      );
    });
  });
}
