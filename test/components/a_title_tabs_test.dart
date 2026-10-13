import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tapping another label calls back; the selected one does not', (
    tester,
  ) async {
    final taps = <int>[];
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: AThemeBuilder.light(
          tone: ATone.fromBrand(const Color(0xFF3182F6)),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: ATitleTabs(
              labels: const ['Bank', 'Workbooks'],
              selectedIndex: 0,
              onSelected: taps.add,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Bank'));
    await tester.tap(find.text('Workbooks'));
    expect(taps, [1]);

    expect(
      tester.getSemantics(find.text('Bank')),
      isSemantics(
        label: 'Bank',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
      ),
    );
    expect(
      tester.getSize(find.byType(InkWell).last).height,
      greaterThanOrEqualTo(48),
    );
    handle.dispose();
  });
}
