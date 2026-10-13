import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(List<String> items, ValueChanged<int> onTap) => MaterialApp(
  theme: AThemeBuilder.light(tone: ATone.fromBrand(const Color(0xFF3182F6))),
  home: Scaffold(
    body: ABreadcrumb(items: items, onTap: onTap),
  ),
);

void main() {
  testWidgets('tapping a parent calls back with its index; current is inert', (
    tester,
  ) async {
    final taps = <int>[];
    await tester.pumpWidget(
      _app(const ['Root', 'English', 'Grade 9'], taps.add),
    );

    await tester.tap(find.text('Root'));
    await tester.tap(find.text('English'));
    await tester.tap(find.text('Grade 9'));
    expect(taps, [0, 1]);
    expect(find.byType(TextButton), findsNWidgets(2));
    expect(
      tester.getSize(find.byType(TextButton).first).height,
      greaterThanOrEqualTo(48),
    );
  });

  testWidgets('scrolls to the end when the path grows', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(300, 600);
    addTearDown(tester.view.reset);

    const short = ['Root', 'A'];
    final long = [for (var i = 0; i < 12; i++) 'Folder $i'];
    await tester.pumpWidget(_app(short, (_) {}));
    await tester.pumpWidget(_app(long, (_) {}));
    await tester.pumpAndSettle();

    final position = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position;
    expect(position.pixels, position.maxScrollExtent);
    expect(position.maxScrollExtent, greaterThan(0));
  });

  testWidgets('shows the current (last) chip on first build', (tester) async {
    await tester.pumpWidget(
      _app(const [
        'Root',
        'English vocabulary',
        'Grade 9 term 1',
        'Unit 3 words',
        'Current',
      ], (_) {}),
    );
    await tester.pump();
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scrollable.position.pixels, scrollable.position.maxScrollExtent);
    expect(scrollable.position.maxScrollExtent, greaterThan(0));
  });
}
