import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

final _theme = AThemeBuilder.light(
  tone: ATone.fromBrand(const Color(0xFF3182F6)),
);

/// "open" 을 누르면 확인 다이얼로그를 띄우고 결과를 [onResult] 로 넘긴다.
Widget _app(ValueChanged<bool> onResult, {bool destructive = false}) =>
    MaterialApp(
      theme: _theme,
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async => onResult(
              await showAConfirmDialog(
                context,
                title: const Text('Delete folder?'),
                content: const Text('This cannot be undone.'),
                confirmLabel: 'Delete',
                destructive: destructive,
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

void main() {
  testWidgets('confirm returns true', (tester) async {
    bool? result;
    await tester.pumpWidget(_app((v) => result = v));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Delete folder?'), findsOneWidget);
    expect(find.text('This cannot be undone.'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('cancel uses MaterialLocalizations label and returns false', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(_app((v) => result = v));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    const label = DefaultMaterialLocalizations();
    await tester.tap(find.text(label.cancelButtonLabel));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('barrier dismiss returns false', (tester) async {
    bool? result;
    await tester.pumpWidget(_app((v) => result = v));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(find.byType(ADialog), findsNothing);
    expect(result, isFalse);
  });

  testWidgets('destructive confirm uses colorScheme.error', (tester) async {
    await tester.pumpWidget(_app((_) {}, destructive: true));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Delete'),
    );
    expect(
      button.style?.backgroundColor?.resolve({}),
      _theme.colorScheme.error,
    );
  });

  testWidgets('ADialog is at most 400 wide and lays actions side by side', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 800);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: _theme,
        home: ADialog(
          title: const Text('Title'),
          actions: [
            FilledButton(onPressed: () {}, child: const Text('A')),
            FilledButton(onPressed: () {}, child: const Text('B')),
          ],
        ),
      ),
    );

    final surface = find
        .descendant(of: find.byType(Dialog), matching: find.byType(Material))
        .first;
    expect(tester.getSize(surface).width, lessThanOrEqualTo(400));
    final a = tester.getRect(find.widgetWithText(FilledButton, 'A'));
    final b = tester.getRect(find.widgetWithText(FilledButton, 'B'));
    expect(a.top, b.top);
    expect(a.width, b.width);
  });
}
