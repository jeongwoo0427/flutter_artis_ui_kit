import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AThemeBuilder.light(tone: ATone.fromBrand(const Color(0xFF3182F6))),
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void main() {
  testWidgets('ASectionCard shows header, count in primary, trailing', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        ASectionCard(
          title: const Text('Folders'),
          count: const Text('3'),
          trailing: TextButton(onPressed: () {}, child: const Text('All')),
          child: const Text('Body'),
        ),
      ),
    );
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    final cs = Theme.of(tester.element(find.text('3'))).colorScheme;
    expect(
      DefaultTextStyle.of(tester.element(find.text('3'))).style.color,
      cs.primary,
    );
    expect(
      tester.getSemantics(find.text('Folders')),
      matchesSemantics(label: 'Folders', isHeader: true),
    );
    handle.dispose();
  });

  testWidgets('ASectionCard without header builds just the child', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const ASectionCard(child: Text('Only'))));
    expect(find.byType(Row), findsNothing);
  });

  testWidgets('ASectionHeader variants build as headers', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        const Column(
          children: [
            ASectionHeader('Page', variant: ASectionHeaderVariant.page),
            ASectionHeader('Group'),
            ASectionHeader('Field', variant: ASectionHeaderVariant.field),
          ],
        ),
      ),
    );
    for (final label in ['Page', 'Group', 'Field']) {
      expect(
        tester.getSemantics(find.text(label)),
        matchesSemantics(label: label, isHeader: true),
      );
    }
    handle.dispose();
  });

  testWidgets('AKeyValueRow right-aligns the value', (tester) async {
    await tester.pumpWidget(
      _app(const AKeyValueRow(label: Text('Time'), value: Text('10 min'))),
    );
    final row = tester.getRect(find.byType(AKeyValueRow));
    expect(tester.getRect(find.text('10 min')).right, row.right);
    expect(tester.getRect(find.text('Time')).left, row.left);
  });

  testWidgets('AStatGroup splits equal columns with dividers', (tester) async {
    await tester.pumpWidget(
      _app(
        const AStatGroup(
          stats: [
            AStat(label: 'Solved', value: '1,284'),
            AStat(label: 'Made', value: '156'),
            AStat(label: 'Active', value: '3', valueColor: Colors.transparent),
          ],
        ),
      ),
    );
    expect(find.byType(VerticalDivider), findsNWidgets(2));
    expect(find.text('1,284'), findsOneWidget);
    final value = tester.widget<Text>(find.text('3'));
    expect(value.style?.color, Colors.transparent);
    expect(
      value.style?.fontFeatures,
      contains(const FontFeature.tabularFigures()),
    );
  });
}
