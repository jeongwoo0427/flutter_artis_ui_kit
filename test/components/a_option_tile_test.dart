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
      _wrap(AOptionTile(label: const Text('서울'), onTap: () => taps++)),
    );
    await tester.tap(find.text('서울'));
    expect(taps, 1);
  });

  for (final state in AOptionState.values) {
    testWidgets('$state — 시맨틱 selected', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(AOptionTile(label: const Text('A'), state: state, onTap: () {})),
      );
      expect(
        tester.getSemantics(find.byType(AOptionTile)),
        isSemantics(
          isButton: true,
          isEnabled: true,
          isSelected: state != AOptionState.idle,
        ),
      );
      handle.dispose();
    });
  }

  testWidgets('onTap 이 null 이면 비활성', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_wrap(const AOptionTile(label: Text('A'))));
    expect(
      tester.getSemantics(find.byType(AOptionTile)),
      isSemantics(isButton: true, isEnabled: false),
    );
    handle.dispose();
  });

  testWidgets('numbered 는 번호를 보여 주고 selected 면 체크가 붙는다', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AOptionTile.numbered(
          number: 3,
          label: const Text('부산'),
          state: AOptionState.selected,
          onTap: () {},
        ),
      ),
    );
    expect(find.text('3'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('글자 2배에서도 넘치지 않는다', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: _wrap(
          AOptionTile.numbered(
            number: 1,
            label: const Text('아주 긴 선택지 문구가 두 줄 이상으로 넘어가는 경우'),
            onTap: () {},
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
