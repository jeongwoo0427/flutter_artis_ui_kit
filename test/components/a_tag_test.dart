import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

final _tone = ATone.fromBrand(const Color(0xFF3182F6));

Widget _wrap(ThemeData theme, Widget child) => MaterialApp(
  theme: theme,
  home: Scaffold(body: Center(child: child)),
);

double _contrastOf(WidgetTester tester) {
  final box = tester.widget<DecoratedBox>(
    find.descendant(of: find.byType(ATag), matching: find.byType(DecoratedBox)),
  );
  final bg = (box.decoration as BoxDecoration).color!;
  final fg = tester.widget<RichText>(find.byType(RichText)).text.style!.color!;
  return contrastRatio(fg, bg);
}

void main() {
  for (final (name, theme) in [
    ('light', AThemeBuilder.light(tone: _tone)),
    ('dark', AThemeBuilder.dark(tone: _tone)),
  ]) {
    final semantic = theme.extension<AThemeData>()!.semantic;
    for (final (role, color) in [
      ('positive', semantic.positive),
      ('negative', semantic.negative),
      ('warning', semantic.warning),
    ]) {
      testWidgets('$name · $role — 글자 대비 4.5 이상', (tester) async {
        await tester.pumpWidget(_wrap(theme, ATag('정답', color: color)));
        expect(_contrastOf(tester), greaterThanOrEqualTo(4.5));
      });
    }
  }

  testWidgets('회색 · primary · 아이콘 · 크기 모두 그려진다', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AThemeBuilder.light(tone: _tone),
        Wrap(
          children: [
            for (final size in ATagSize.values) ...[
              ATag('기본', size: size),
              ATag.primary('AI', size: size, icon: const Icon(Icons.bolt)),
            ],
          ],
        ),
      ),
    );
    expect(find.text('기본'), findsNWidgets(3));
    expect(find.byIcon(Icons.bolt), findsNWidgets(3));
  });

  testWidgets('폭이 무한한 Row 안에서도 깨지지 않는다', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AThemeBuilder.light(tone: _tone),
        const Row(children: [ATag('Row 안', icon: Icon(Icons.star))]),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
