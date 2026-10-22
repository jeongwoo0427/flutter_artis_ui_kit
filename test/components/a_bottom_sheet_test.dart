import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

final _theme = AThemeBuilder.light(
  tone: ATone.fromBrand(const Color(0xFF3182F6)),
);

/// [onOpen] 은 "open" 버튼을 누르면 불린다.
Widget _app(void Function(BuildContext context) onOpen) => MaterialApp(
  theme: _theme,
  home: Scaffold(
    body: Builder(
      builder: (context) => TextButton(
        onPressed: () => onOpen(context),
        child: const Text('open'),
      ),
    ),
  ),
);

void main() {
  testWidgets('showABottomSheet shows title/child and returns popped value', (
    tester,
  ) async {
    String? result;
    await tester.pumpWidget(
      _app((context) async {
        result = await showABottomSheet<String>(
          context,
          title: const Text('Title'),
          subtitle: const Text('Subtitle'),
          builder: (context) => TextButton(
            onPressed: () => Navigator.pop(context, 'picked'),
            child: const Text('Pick'),
          ),
          action: const Text('Action'),
        );
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Subtitle'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.byType(ABottomSheetScaffold), findsOneWidget);

    await tester.tap(find.text('Pick'));
    await tester.pumpAndSettle();
    expect(result, 'picked');
    expect(find.text('Title'), findsNothing);
  });

  testWidgets('opens on the root navigator by default', (tester) async {
    const nested = Key('nested');
    await tester.pumpWidget(
      MaterialApp(
        theme: _theme,
        home: Navigator(
          key: nested,
          onGenerateRoute: (_) => MaterialPageRoute<void>(
            builder: (context) => TextButton(
              onPressed: () => showABottomSheet<void>(
                context,
                builder: (_) => const Text('Sheet body'),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final navigator = find
        .ancestor(of: find.text('Sheet body'), matching: find.byType(Navigator))
        .first;
    expect(tester.widget(navigator).key, isNot(nested));
  });

  testWidgets('tall content scrolls instead of overflowing', (tester) async {
    await tester.pumpWidget(
      _app((context) {
        showABottomSheet<void>(
          context,
          title: const Text('Tall'),
          builder: (_) => const SizedBox(height: 2000),
          action: const Text('Action'),
        );
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Action'), findsOneWidget);
    final screen = tester.getSize(find.byType(Scaffold)).height;
    expect(
      tester.getSize(find.byType(ABottomSheetScaffold)).height,
      lessThanOrEqualTo(screen * 0.85 + 0.1),
    );
  });

  testWidgets('showAActionSheet returns the tapped item value', (tester) async {
    int? result = -1;
    await tester.pumpWidget(
      _app((context) async {
        result = await showAActionSheet<int>(
          context,
          title: const Text('Actions'),
          items: const [
            AActionSheetItem(label: 'Rename', value: 1, icon: Icon(Icons.edit)),
            AActionSheetItem(
              label: 'Move',
              value: 2,
              subtitle: 'To another folder',
            ),
          ],
        );
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('To another folder'), findsOneWidget);

    await tester.tap(find.text('Move'));
    await tester.pumpAndSettle();
    expect(result, 2);
  });

  testWidgets('dismissing the action sheet returns null', (tester) async {
    int? result = -1;
    await tester.pumpWidget(
      _app((context) async {
        result = await showAActionSheet<int>(
          context,
          items: const [AActionSheetItem(label: 'Rename', value: 1)],
        );
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });

  testWidgets('selected item shows a primary check', (tester) async {
    await tester.pumpWidget(
      _app((context) {
        showAActionSheet<int>(
          context,
          items: const [
            AActionSheetItem(label: 'Light', value: 0),
            AActionSheetItem(label: 'Dark', value: 1, selected: true),
          ],
        );
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final check = tester.widget<Icon>(find.byIcon(Icons.check_rounded));
    expect(check.color, _theme.colorScheme.primary);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('destructive item uses colorScheme.error', (tester) async {
    await tester.pumpWidget(
      _app((context) {
        showAActionSheet<int>(
          context,
          items: const [
            AActionSheetItem(label: 'Keep', value: 0, icon: Icon(Icons.edit)),
            AActionSheetItem(
              label: 'Delete',
              value: 1,
              icon: Icon(Icons.delete),
              destructive: true,
            ),
          ],
        );
      }),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final error = _theme.colorScheme.error;
    Color? textColor(String s) =>
        tester.widget<Text>(find.text(s)).style?.color;
    Color? iconColor(IconData icon) =>
        IconTheme.of(tester.element(find.byIcon(icon))).color;

    expect(textColor('Delete'), error);
    expect(iconColor(Icons.delete), error);
    expect(textColor('Keep'), isNot(error));
    expect(iconColor(Icons.edit), isNot(error));
  });
}
