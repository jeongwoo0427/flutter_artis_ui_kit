import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AThemeBuilder.light(tone: ATone.fromBrand(const Color(0xFF3182F6))),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('tap calls onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(AButton(onPressed: () => taps++, child: const Text('Save'))),
    );
    await tester.tap(find.text('Save'));
    expect(taps, 1);
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('null onPressed disables with disabled colors', (tester) async {
    await tester.pumpWidget(
      _app(const AButton(onPressed: null, child: Text('Save'))),
    );
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.enabled, isFalse);
    final context = tester.element(find.byType(FilledButton));
    final cs = Theme.of(context).colorScheme;
    const disabled = {WidgetState.disabled};
    expect(
      button.style!.backgroundColor!.resolve(disabled),
      cs.surfaceContainerHigh,
    );
    expect(button.style!.foregroundColor!.resolve(disabled), cs.outline);
  });

  testWidgets('loading shows a spinner, keeps colors and ignores taps', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(
        AButton(
          onPressed: () => taps++,
          isLoading: true,
          child: const Text('Save'),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // 라벨은 폭 유지를 위해 투명하게 남아 있다.
    expect(find.text('Save'), findsOneWidget);
    await tester.tap(find.byType(AButton));
    expect(taps, 0);

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    final cs = Theme.of(tester.element(find.byType(FilledButton))).colorScheme;
    expect(
      button.style!.backgroundColor!.resolve({WidgetState.disabled}),
      cs.primary,
    );
  });

  testWidgets('loading keeps the button width', (tester) async {
    Widget build(bool loading) => _app(
      AButton(
        onPressed: () {},
        isLoading: loading,
        child: const Text('A long label'),
      ),
    );
    await tester.pumpWidget(build(false));
    final idle = tester.getSize(find.byType(AButton));
    await tester.pumpWidget(build(true));
    expect(tester.getSize(find.byType(AButton)), idle);
  });

  testWidgets('every variant and size builds; small keeps a 48 hit area', (
    tester,
  ) async {
    final buttons = <Widget>[
      AButton(onPressed: () {}, child: const Text('primary')),
      AButton.tonal(onPressed: () {}, child: const Text('tonal')),
      AButton.neutral(onPressed: () {}, child: const Text('neutral')),
      AButton.danger(onPressed: () {}, child: const Text('danger')),
      AButton.text(onPressed: () {}, child: const Text('text')),
      AButton(
        onPressed: () {},
        size: AButtonSize.medium,
        icon: const Icon(Icons.add),
        child: const Text('medium'),
      ),
      AButton(
        onPressed: () {},
        size: AButtonSize.small,
        child: const Text('small'),
      ),
    ];
    await tester.pumpWidget(
      _app(SingleChildScrollView(child: Column(children: buttons))),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(
      tester.getSize(find.byType(FilledButton).first).height,
      greaterThanOrEqualTo(56),
    );
    expect(
      tester.getSize(find.byType(FilledButton).last).height,
      greaterThanOrEqualTo(48),
    );
  });

  testWidgets('press scales down, and not when animations are off', (
    tester,
  ) async {
    Future<double> pressedScale({required bool disable}) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(disableAnimations: disable),
          child: _app(AButton(onPressed: () {}, child: const Text('Go'))),
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Go')),
      );
      await tester.pumpAndSettle();
      final scale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      await gesture.up();
      await tester.pumpAndSettle();
      return scale.scale;
    }

    expect(await pressedScale(disable: false), lessThan(1));
    expect(await pressedScale(disable: true), 1);
  });

  testWidgets('brandFill tone — primary button is the brand with dark text', (
    tester,
  ) async {
    const golden = Color(0xFFFFC800);
    await tester.pumpWidget(
      MaterialApp(
        theme: AThemeBuilder.light(
          tone: ATone.fromBrand(golden, brandFill: true),
        ),
        home: Scaffold(
          body: Center(
            child: AButton(onPressed: () {}, child: const Text('Go')),
          ),
        ),
      ),
    );
    final button = tester.widget<ButtonStyleButton>(
      find.byWidgetPredicate((w) => w is ButtonStyleButton),
    );
    expect(button.style!.backgroundColor!.resolve({}), golden);
    final fg = button.style!.foregroundColor!.resolve({})!;
    expect(contrastRatio(fg, golden), greaterThan(7));
  });
}
