import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AThemeBuilder.light(tone: ATone.fromBrand(const Color(0xFF3182F6))),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('탭하면 onTap 이 불린다', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        APickCard(
          leading: const Text('📝'),
          title: const Text('객관식'),
          subtitle: const Text('보기 중 고르기'),
          onTap: () => taps++,
        ),
      ),
    );
    await tester.tap(find.text('객관식'));
    expect(taps, 1);
    expect(find.text('보기 중 고르기'), findsOneWidget);
  });

  for (final selected in [false, true]) {
    testWidgets('selected=$selected — 시맨틱', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          APickCard(title: const Text('주관식'), selected: selected, onTap: () {}),
        ),
      );
      expect(
        tester.getSemantics(find.byType(APickCard)),
        isSemantics(isButton: true, isSelected: selected),
      );
      handle.dispose();
    });
  }
}
