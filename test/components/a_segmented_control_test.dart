import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AThemeBuilder.light(tone: ATone.fromBrand(const Color(0xFF3182F6))),
  home: Scaffold(
    body: Center(child: SizedBox(width: 300, child: child)),
  ),
);

/// 부모가 값을 들고 바꾸는 세그먼트 — 실제 쓰임과 같다.
class _Host extends StatefulWidget {
  const _Host({
    this.initial = 0,
    this.disabled = const {},
    this.onDisabledTap,
    this.changes,
  });

  final int initial;
  final Set<int> disabled;
  final ValueChanged<int>? onDisabledTap;
  final List<int>? changes;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late int value = widget.initial;

  @override
  Widget build(BuildContext context) => ASegmentedControl<int>(
    segments: [
      for (var i = 0; i < 3; i++)
        ASegment(
          value: i,
          label: Text('칸$i'),
          enabled: !widget.disabled.contains(i),
        ),
    ],
    selected: value,
    onChanged: (v) {
      widget.changes?.add(v);
      setState(() => value = v);
    },
    onDisabledTap: widget.onDisabledTap,
  );
}

void main() {
  testWidgets('칸을 누르면 그 값으로 바뀐다', (tester) async {
    final changes = <int>[];
    await tester.pumpWidget(_wrap(_Host(changes: changes)));
    await tester.tap(find.text('칸2'));
    await tester.pumpAndSettle();
    expect(changes, [2]);
  });

  testWidgets('고른 칸을 잡고 끌면 놓은 칸으로 바뀐다', (tester) async {
    final changes = <int>[];
    await tester.pumpWidget(_wrap(_Host(changes: changes)));
    final from = tester.getCenter(find.text('칸0'));
    final to = tester.getCenter(find.text('칸2'));
    await tester.dragFrom(from, to - from);
    await tester.pumpAndSettle();
    expect(changes, [2]);
  });

  testWidgets('고르지 않은 칸에서 시작한 끌기는 아무것도 바꾸지 않는다', (tester) async {
    final changes = <int>[];
    await tester.pumpWidget(_wrap(_Host(changes: changes)));
    final from = tester.getCenter(find.text('칸1'));
    final to = tester.getCenter(find.text('칸2'));
    await tester.dragFrom(from, to - from);
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
  });

  testWidgets('비활성 칸은 고를 수 없고 onDisabledTap 을 부른다', (tester) async {
    final changes = <int>[];
    final disabledTaps = <int>[];
    await tester.pumpWidget(
      _wrap(
        _Host(
          changes: changes,
          disabled: const {1},
          onDisabledTap: disabledTaps.add,
        ),
      ),
    );
    await tester.tap(find.text('칸1'));
    await tester.pumpAndSettle();
    expect(changes, isEmpty);
    expect(disabledTaps, [1]);
  });

  testWidgets('폭이 열린 Row 안에서도 그려진다(가장 긴 칸에 맞춘 같은 폭)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AThemeBuilder.light(
          tone: ATone.fromBrand(const Color(0xFF3182F6)),
        ),
        home: Scaffold(
          body: Row(
            children: [
              const Expanded(child: Text('제목')),
              ASegmentedControl<int>(
                segments: const [
                  ASegment(value: 0, label: Text('기본')),
                  ASegment(value: 1, label: Text('시험지풍입니다')),
                ],
                selected: 0,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    final a = tester.getSize(
      find.ancestor(of: find.text('기본'), matching: find.byType(Expanded)).first,
    );
    final b = tester.getSize(
      find
          .ancestor(of: find.text('시험지풍입니다'), matching: find.byType(Expanded))
          .first,
    );
    expect(a.width, b.width);
  });

  testWidgets('부제가 있는 칸 — 글자와 부제를 그린다', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ASegmentedControl<int>(
          segments: const [
            ASegment(value: 0, label: Text('시험지'), subtitle: Text('A4')),
            ASegment(value: 1, label: Text('요약')),
          ],
          selected: 0,
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.text('A4'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('시맨틱 — 고른 칸만 selected', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_wrap(const _Host(initial: 1)));
    expect(
      tester.getSemantics(find.text('칸1')),
      isSemantics(
        isButton: true,
        isSelected: true,
        isInMutuallyExclusiveGroup: true,
      ),
    );
    expect(
      tester.getSemantics(find.text('칸0')),
      isSemantics(
        isButton: true,
        isSelected: false,
        isInMutuallyExclusiveGroup: true,
      ),
    );
    handle.dispose();
  });
}
