import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AThemeBuilder.light(tone: ATone.fromBrand(const Color(0xFF3182F6))),
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(20), child: child),
  ),
);

void main() {
  testWidgets('tap and long press call back; min height 56', (tester) async {
    final events = <String>[];
    await tester.pumpWidget(
      _app(
        AListRow(
          title: const Text('Folder'),
          subtitle: const Text('12 questions'),
          leading: const Icon(Icons.folder),
          trailing: const Text('3'),
          showChevron: true,
          onTap: () => events.add('tap'),
          onLongPress: () => events.add('long'),
        ),
      ),
    );
    await tester.tap(find.text('Folder'));
    await tester.longPress(find.text('Folder'));
    expect(events, ['tap', 'long']);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    expect(
      tester.getSize(find.byType(AListRow)).height,
      greaterThanOrEqualTo(56),
    );
  });

  testWidgets('selected is announced and merged into one node', (tester) async {
    final handle = tester.ensureSemantics();
    Future<void> pump(bool selected) => tester.pumpWidget(
      _app(
        AListRow(
          title: const Text('Folder'),
          subtitle: const Text('12 questions'),
          selected: selected,
          onTap: () {},
        ),
      ),
    );

    await pump(true);
    expect(
      tester.getSemantics(find.byType(AListRow)),
      matchesSemantics(
        label: 'Folder\n12 questions',
        isSelected: true,
        hasSelectedState: true,
        isButton: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );

    await pump(false);
    expect(
      tester.getSemantics(find.byType(AListRow)),
      matchesSemantics(
        label: 'Folder\n12 questions',
        hasSelectedState: true,
        isButton: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('title is clamped to two lines', (tester) async {
    await tester.pumpWidget(
      _app(AListRow(title: Text('Very long title ' * 30))),
    );
    final text = tester.widget<RichText>(
      find.descendant(
        of: find.byType(AListRow),
        matching: find.byType(RichText),
      ),
    );
    expect(text.maxLines, 2);
    expect(text.overflow, TextOverflow.ellipsis);
  });
}
